import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/UsuarioBloc.dart';

class PedidoHeader extends StatelessWidget {

  final DocumentSnapshot pedido;

  PedidoHeader(this.pedido);

  @override
  Widget build(BuildContext context) {

    final _userBloc = BlocProvider.of<UsuarioBloc>(context);
    final _usuario = _userBloc.getUsuario(pedido.data["idCliente"]);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_usuario["nome"]}"),
              Text("${_usuario["endereco"]}")
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Produtos: R\$${pedido.data["precosProdutos"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500),),
            Text("Total R\$${pedido.data["totalPreco"].toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500))
          ],
        )
      ],
    );
  }
}
