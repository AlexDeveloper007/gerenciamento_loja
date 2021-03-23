import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/CategoriaBloc.dart';

import 'ImageSourceSheet.dart';

class EditarCategoriaDialog extends StatefulWidget {

  final DocumentSnapshot categoria;

  EditarCategoriaDialog({this.categoria});

  @override
  _EditarCategoriaDialogState createState() => _EditarCategoriaDialogState(
    categoria: categoria
  );
}

class _EditarCategoriaDialogState extends State<EditarCategoriaDialog> {
  final CategoriaBloc _categoriaBloc;

  final TextEditingController _controller;

  _EditarCategoriaDialogState({DocumentSnapshot categoria}) :
        _categoriaBloc = CategoriaBloc(categoria),
        _controller = TextEditingController(text: categoria != null
            ? categoria.data["titulo"]
            : "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context) => ImageSourceSheet(
                      onImagemSelecionada: (imagem){
                        Navigator.of(context).pop();
                        _categoriaBloc.setImagem(imagem);
                      },
                    )
                );
              },
              leading: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: StreamBuilder(
                        stream: _categoriaBloc.outImagem,
                        builder: (context, snapshot) {
                          if(snapshot.data != null){
                            //tem imagem
                            return CircleAvatar(
                              child: snapshot.data is File
                                  ? Image.file(snapshot.data, fit: BoxFit.cover )
                                  : Image.network(snapshot.data, fit: BoxFit.cover,),
                              backgroundColor: Colors.transparent,
                            );
                          }else{
                            return Icon(Icons.image, size: 32,);
                          }
                        }
                    ),
                  )
              ),
              title: StreamBuilder<String>(
                stream: _categoriaBloc.outTitulo,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controller,
                    onChanged: _categoriaBloc.setTitulo,
                    decoration: InputDecoration(
                      errorText: snapshot.hasError ? snapshot.error
                          : null
                    ),
                  );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: _categoriaBloc.outDeletar,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Container();
                      }else{
                        return FlatButton(
                          child: Text("Excluir"),
                          textColor: Colors.red,
                          onPressed: snapshot.data ? (){
                            _categoriaBloc.deletar();
                            Navigator.of(context).pop();
                          } : null,
                        );
                      }
                    }
                ),
                StreamBuilder<bool>(
                  stream: _categoriaBloc.submitValid,
                  builder: (context, snapshot) {
                    return FlatButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(
                            color: snapshot.hasData ? Colors.green : Colors.grey
                        ),
                      ),
                      onPressed: snapshot.hasData
                          ? () async{
                            //await _categoriaBloc.salvarDados();
                            _categoriaBloc.salvarDados();
                            Navigator.pop(context);
                          }
                          : null,
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
