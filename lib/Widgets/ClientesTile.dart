import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ClientesTile extends StatelessWidget {

  final Map<String, dynamic> usuario;

  ClientesTile(this.usuario);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(color: Colors.white);

    if(usuario.containsKey("gastou")){
      //já carregou os dados necessários
      return ListTile(
        title: Text(
          usuario["nome"],
          style: textStyle,
        ),
        subtitle: Text(
          usuario["email"],
          style: textStyle,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Pedidos: ${usuario["pedidos"]}",
              style: textStyle,
            ),
            Text(
              "Gasto: R\$${usuario["gastou"].toStringAsFixed(2)}",
              style: textStyle,
            )
          ],
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            ),
            SizedBox(
              width: 70,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            )
          ],
        ),
      );
    }


  }
}
