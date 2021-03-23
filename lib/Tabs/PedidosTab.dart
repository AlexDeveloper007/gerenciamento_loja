import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/PedidosBloc.dart';
import 'package:gerenciamento_loja/Widgets/PedidoCard.dart';

class PedidosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _pedidosBloc = BlocProvider.of<PedidosBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
        stream: _pedidosBloc.outPedidos,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
              ),
            );
          }
          else if(snapshot.data.length == 0){
            //lista vazia
            return Center(
              child: Text("Nenhum pedido encontrado!",
              style: TextStyle(color: Colors.pinkAccent),),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return PedidoCard(snapshot.data[index]);
            },
          );
        }
      ),
    );
  }
}
