import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/UsuarioBloc.dart';
import 'package:gerenciamento_loja/Widgets/ClientesTile.dart';

class ClientesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final _userBloc = BlocProvider.of<UsuarioBloc>(context);

    return Column(
      children: [
        //Campo de texto
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white,),
                icon: Icon(Icons.search, color: Colors.white,),
                border: InputBorder.none
            ),
            onChanged: _userBloc.onChangedPesquisa,
          ),
        ),
        //lista
        Expanded(
          child: StreamBuilder<List>(
            stream: _userBloc.outUsuarios,
            builder: (context, snapshot) {

              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),
                );
              }else if(snapshot.data.length == 0){
                return Center(
                  child: Text(
                      "Nenhum usuário encontrado!",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                );
              }else{
                //tem dados e a lista não é vazia
                return ListView.separated(
                    itemBuilder: (context, index){
                      return ClientesTile(snapshot.data[index]);
                    },
                    separatorBuilder: (context, index){
                      return Divider();
                    },
                    itemCount: snapshot.data.length
                );
              }
            }
          ),
        )
      ],
    );
  }
}
