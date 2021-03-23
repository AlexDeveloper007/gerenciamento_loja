
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProdutoBloc extends BlocBase{

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String idCategoria;
  DocumentSnapshot produto;

  Map<String, dynamic> unsavedData;

  ProdutoBloc({this.idCategoria, this.produto}){
    if(produto != null){
      //cópia exata de como estava o produto
      unsavedData = Map.of(produto.data);
      unsavedData["imagens"] = List.of(produto.data["imagens"]);
      if(produto.data["tamanhos"] != null)
      unsavedData["tamanhos"] = List.of(produto.data["tamanhos"]);

      //habilitar botão remover se o produto está criado
      _createdController.add(true);
    }else{
      unsavedData = {
        "titulo" : null,
        "descricao" : null,
        "preco" : null,
        "imagens" : null,
        "tamanhos" : null
      };
      //Desabilitar botão remover se o produto não está criado
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void salvarTitulo(String titulo){
    unsavedData["titulo"] = titulo;
  }

  void salvarDescricao(String descricao){
    unsavedData["descricao"] = descricao;
  }

  void salvarPreco(String preco){
    unsavedData["preco"] = double.parse(preco);
  }

  void salvarImagens(List imagens){
    unsavedData["imagens"] = imagens;
  }

  void salvarTamanhos(List tamanhos){
    unsavedData["tamanhos"] = tamanhos;
  }

  Future<bool> salvarProduto() async{
    _loadingController.add(true);

    //Função de Delayed
    //await Future.delayed(Duration(seconds: 3));

    try{
      if(produto != null){
        await _uploadImagens(produto.documentID);
        await produto.reference.updateData(unsavedData);
      }else{
        //Salvar todos os dados do produto menos as imagens
        DocumentReference documentReference = await Firestore.instance.collection("produtos").document(idCategoria)
            .collection("itens").add(Map.from(unsavedData)..remove("imagens"));

        await _uploadImagens(documentReference.documentID);
        await documentReference.updateData(unsavedData);
      }
      _createdController.add(true);
      _loadingController.add(false);
      return true;
    }catch(erro){
      _loadingController.add(false);
      return false;
    }
  }

  void deletarProduto(){
    produto.reference.delete();
  }


  Future _uploadImagens(String produtoId) async {

    for(int i = 0; i < unsavedData["imagens"].length; i++){
      //verificar se a imagem já está no firebase
      if (unsavedData["imagens"][i] is String){
        continue;
      }

      //Fazer upload da imagem no firebase
      StorageUploadTask uploadTask =
      FirebaseStorage.instance.ref().child(idCategoria).child(produtoId)
      .child(DateTime.now().millisecondsSinceEpoch.toString())
      .putFile(unsavedData["imagens"][i]);

      //Esperar o upload ser completo e pegar a url da imagem
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String urlImagem = await snapshot.ref.getDownloadURL();

      unsavedData["imagens"][i] = urlImagem;
    }

  }



  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }



}
