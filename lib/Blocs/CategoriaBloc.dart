
import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoriaBloc extends BlocBase {

  final _tituloController  = BehaviorSubject<String>();
  final _imagemController  = BehaviorSubject();
  final _deletarController = BehaviorSubject<bool>();

  Stream<String> get outTitulo => _tituloController.stream.transform(
    StreamTransformer<String, String>.fromHandlers(
      handleData: (titulo, sink){
        if(titulo.isEmpty){
          sink.addError("Insira um título!");
        }else{
          sink.add(titulo);
        }
      }
    )
  );
  Stream get outImagem => _imagemController.stream;
  Stream<bool> get outDeletar => _deletarController.stream;
  
  Stream<bool> get submitValid => Observable.combineLatest2(
    //passar true quando tiver dados
    outTitulo, outImagem, (a, b) => true
  );

  DocumentSnapshot categoria;

  String titulo;
  File imagem;

  CategoriaBloc(this.categoria){
    if(categoria != null){
      titulo = categoria.data["titulo"];

      _tituloController.add(categoria.data["titulo"]);
      _imagemController.add(categoria.data["icone"]);
      _deletarController.add(true);
    }else{
      _deletarController.add(false);
    }
  }

  void setImagem(File file){
    imagem = file;
    _imagemController.add(file);
  }

  void setTitulo(String titulo){
    this.titulo = titulo;
    _tituloController.add(titulo);
  }

  void deletar(){
    categoria.reference.delete();
  }

  Future salvarDados() async{
    Map<String, dynamic> dadosToUpdate = {};

    if(imagem == null && categoria != null && titulo == categoria.data["titulo"]){
      //nada mudou
      return;
    }else{

      if(imagem != null){
        //Fazer upload da imagem
        StorageUploadTask task = FirebaseStorage.instance.ref().child("icones")
            .child(titulo).putFile(imagem);

        StorageTaskSnapshot snap = await task.onComplete;
        String urlImagem = await snap.ref.getDownloadURL();
        dadosToUpdate["icone"] = urlImagem;
      }
    }

    if(categoria == null || titulo != categoria.data["titulo"]){
      dadosToUpdate["titulo"] = titulo;
    }

    if(categoria == null){
      await Firestore.instance.collection("produtos").document(titulo.toLowerCase())
      .setData(dadosToUpdate);
    }else{
      await categoria.reference.updateData(dadosToUpdate);
    }

  }


  @override
  void dispose() {
    _tituloController.close();
    _imagemController.close();
    _deletarController.close();
  }



}