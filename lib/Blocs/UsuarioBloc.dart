import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc extends BlocBase{

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsuarios => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};
  Firestore _firestore = Firestore.instance;

  UsuarioBloc(){
    _addUsuarioListeners();
  }

  void onChangedPesquisa(String pesquisa){
    //.trim() == remove os espaços vazio da string
    String pesquisaSemEspaco = pesquisa.trim();
    if(pesquisaSemEspaco.isEmpty){
      _usersController.add(_users.values.toList());
    }else{
      _usersController.add(_filtrar(pesquisaSemEspaco));
    }
  }

  List<Map<String, dynamic>>_filtrar(String pesquisa){

    List<Map<String, dynamic>> filtroUsuarios = List.from(_users.values.toList());

    filtroUsuarios.retainWhere((usuario) {
      return usuario["nome"].toUpperCase().contains(pesquisa.toUpperCase());
    });

    return filtroUsuarios;

  }


  void _addUsuarioListeners(){
    _firestore.collection("usuarios").snapshots().listen((snapshot) {
      //pegar as mudanças do documentos -- forEach == a cada mudança
      snapshot.documentChanges.forEach((change) {

        String uid = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            //quando um usuário for adicionado na coleção
            _users[uid] = change.document.data;
            //observar pedidos do usuário
            _subscribeToOrders(uid);

            break;
          case DocumentChangeType.modified:
            //quando um usuário for modificado
            _users[uid].addAll(change.document.data);
            //Quando modificar algum dado do usuário
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            //não precisa mais observar os pedidos pois o usuário foi removido
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }
  
  void _subscribeToOrders(String uid) {
    _users[uid]["subscription"] =_firestore.collection("usuarios").document(uid)
        .collection("pedidos").snapshots().listen((pedidos) async{
          //lista de pedidos
          int numPedidos = pedidos.documents.length;

          double gastou = 0.0;

          //pra cada pedido do usuário
          for(DocumentSnapshot document in pedidos.documents){
            DocumentSnapshot pedido = await _firestore
                .collection("pedidos")
                .document(document.documentID)
                .get();

            if(pedido.data == null) {
              continue;
            }

            gastou += pedido.data["totalPreco"];
          }

          _users[uid].addAll(
            {"gastou" : gastou, "pedidos": numPedidos}
          );

          _usersController.add(_users.values.toList());
    });
  }

  Map<String, dynamic> getUsuario(String uid){
    return _users[uid];
  }

  void _unsubscribeToOrders(String uid){
    _users[uid]["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }



}
