import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriterio {CONCLUIDOS_PRIMEIRO, CONCLUIDOS_ULTIMO}

class PedidosBloc extends BlocBase {

  final _pedidosController = BehaviorSubject<List>();

  Stream<List> get outPedidos => _pedidosController.stream;

  Firestore _firestore = Firestore.instance;

  SortCriterio _criterio;

  List<DocumentSnapshot>_pedidos = List();

  PedidosBloc(){
    addPedidosListener();
  }

  void addPedidosListener(){
    _firestore.collection("pedidos").snapshots().listen((snapshot) {

      snapshot.documentChanges.forEach((change) {
        String pedidoId = change.document.documentID;

        switch(change.type){
          case DocumentChangeType.added:
            _pedidos.add(change.document);
            break;
          case DocumentChangeType.modified:
            _pedidos.removeWhere((pedido) => pedido.documentID == pedidoId);
            _pedidos.add(change.document);
            break;
          case DocumentChangeType.removed:
            _pedidos.removeWhere((pedido) => pedido.documentID == pedidoId);
            break;
        }
      });

      _sort();

    });
  }

  void setFiltroPedido(SortCriterio criterio){
    _criterio = criterio;
    _sort();
  }

  void _sort(){
    switch(_criterio){
      case SortCriterio.CONCLUIDOS_PRIMEIRO:
        _pedidos.sort(( a, b) {
          int statusA = a.data["status"];
          int statusB = b.data["status"];

          if(statusA < statusB){
            return 1;
          }else if(statusA > statusB){
            return -1;
          }else{
            return 0;
          }
        });
        break;
      case SortCriterio.CONCLUIDOS_ULTIMO:
        _pedidos.sort(( a, b) {
          int statusA = a.data["status"];
          int statusB = b.data["status"];

          if(statusA > statusB){
            return 1;
          }else if(statusA < statusB){
            return -1;
          }else{
            return 0;
          }
        });
        break;
    }
    _pedidosController.add(_pedidos);
  }


  @override
  void dispose() {

    _pedidosController.close();
  }



}
