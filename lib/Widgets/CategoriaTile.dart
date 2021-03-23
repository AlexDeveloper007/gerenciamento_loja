import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Telas/LoginTela.dart';
import 'package:gerenciamento_loja/Telas/ProdutoTela.dart';
import 'package:gerenciamento_loja/Widgets/EditarCategoriaDialog.dart';

class CategoriaTile extends StatelessWidget {

  final DocumentSnapshot categoria;

  CategoriaTile(this.categoria);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              showDialog(context: context,
              builder: (context) => EditarCategoriaDialog(
                categoria: categoria,
                )
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(categoria.data["icone"],),
              backgroundColor: Colors.transparent,
            ),
          ), 
          title: Text(
            categoria.data["titulo"],
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: categoria.reference.collection("itens").snapshots(),
              builder: (context, snapshot){
                print("bbb");
                if(!snapshot.hasData){
                  return Container();
                }else{
                  return Column(
                    children: snapshot.data.documents.map( (doc) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(doc.data["imagens"][0]),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(doc.data["titulo"]),
                        trailing: Text(
                          "R\$${doc.data["preco"].toStringAsFixed(2)}"
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProdutoTela(
                              idCategoria: categoria.documentID,
                              produto: doc,
                            ))
                          );
                        },

                      );
                    }).toList()..add(
                      //colocar mais um widget na lista
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.add, color: Colors.pinkAccent,),
                        ),
                        title: Text("Adicionar"),
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProdutoTela(
                              idCategoria: categoria.documentID,
                            ))
                          );
                        },
                      )
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
