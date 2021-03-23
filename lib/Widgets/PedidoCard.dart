import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'PedidoHeader.dart';

class PedidoCard extends StatelessWidget {

  final DocumentSnapshot pedido;

  PedidoCard(this.pedido);

  final status = [
    "", "Em preparação", "Em transporte", "Aguardando Entrega", "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(pedido.documentID),
          //initiallyExpanded: pedido.data["status"] != 4, //começar expandido
          initiallyExpanded: 1 == 2, //começar expandido
          title: Text(
            "#${pedido.documentID.substring(pedido.documentID.length - 7, pedido.documentID.length)} - "
                "${status[pedido.data["status"]]}",
            style: TextStyle(color: pedido.data["status"] != 4 ? Colors.grey[850] : Colors.green ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //linha 1

                  PedidoHeader(pedido),

                  //linha 2
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                      pedido.data["produtos"].map<Widget>( (produto){
                        return ListTile(
                          title: Text(produto["produto"]["titulo"] + " - " + produto["tamanho"]),
                          subtitle: Text(produto["categoria"] + "/" + produto["idProduto"]),
                          trailing: Text(
                            produto["quantidade"].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                  ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       FlatButton(
                           onPressed: (){
                             //Deletar pedido para o usuário
                             Firestore.instance.collection("usuarios").document(pedido["idCliente"])
                             .collection("pedidos").document(pedido.documentID).delete();
                             //Deltar na lista de pedidos
                             pedido.reference.delete();
                           },
                           textColor: Colors.red,
                           child: Text("Excluir")
                       ),
                       FlatButton(
                           onPressed: pedido.data["status"] > 1 ?
                               (){
                                  //
                                 pedido.reference.updateData({"status" : pedido.data["status"] - 1});
                               }
                               : null,
                           textColor: Colors.grey[850],
                           child: Text("Regredir")
                       ),
                       FlatButton(
                           onPressed: pedido.data["status"] < 4 ?
                               (){
                                 pedido.reference.updateData({"status" : pedido.data["status"] + 1});
                               }
                               : null,
                           textColor: Colors.green,
                           child: Text("Avançar")
                       )
                     ],
                   )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
