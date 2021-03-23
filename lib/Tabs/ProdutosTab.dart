import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Widgets/CategoriaTile.dart';

class ProdutosTab extends StatefulWidget {
  @override
  _ProdutosTabState createState() => _ProdutosTabState();
}

class _ProdutosTabState extends State<ProdutosTab> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("produtos").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }else if(snapshot.data.documents.length == 0){
          return Center(child: Text("Nenhum produto cadastrado!"),);
        }else{
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return CategoriaTile(snapshot.data.documents[index]);
            },
          );
        }
      },
    );

  }

  @override
  bool get wantKeepAlive => true;
}
