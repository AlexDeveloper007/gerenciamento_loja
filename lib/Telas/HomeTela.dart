import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciamento_loja/Blocs/PedidosBloc.dart';
import 'package:gerenciamento_loja/Blocs/UsuarioBloc.dart';
import 'package:gerenciamento_loja/Tabs/ClientesTab.dart';
import 'package:gerenciamento_loja/Tabs/PedidosTab.dart';
import 'package:gerenciamento_loja/Tabs/ProdutosTab.dart';
import 'package:gerenciamento_loja/Widgets/EditarCategoriaDialog.dart';

class HomeTela extends StatefulWidget {
  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {

  PageController _pageController;
  int _page = 0;

  UsuarioBloc _usuarioBloc;
  PedidosBloc _pedidosBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _usuarioBloc = UsuarioBloc();
    _pedidosBloc = PedidosBloc();

    //FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.pinkAccent, //cor do fundo
          primaryColor: Colors.white, //cor item selecionado
          textTheme: Theme.of(context).textTheme.copyWith( //cor itens não selecionados
            caption: TextStyle(color: Colors.white54)
          )
        ),
        child: BottomNavigationBar(
          currentIndex: _page ,
          onTap: (paginaClicada) {
            _pageController.animateToPage(
                paginaClicada,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease
            );
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Clientes"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: "Pedidos"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Produtos"
            )
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UsuarioBloc>(
          bloc: _usuarioBloc,
          child: BlocProvider<PedidosBloc>(
            bloc: _pedidosBloc,
            child: PageView(
              controller: _pageController,
              onPageChanged: (paginaClicada){
                setState(() {
                  _page = paginaClicada;
                });
              },
              children: [
                ClientesTab(),
                PedidosTab(),
                ProdutosTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating(){
    switch(_page){
      case 0:
        return null;
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
                child: Icon(Icons.arrow_downward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: (){
                  _pedidosBloc.setFiltroPedido(SortCriterio.CONCLUIDOS_ULTIMO);
                }
              ),
            SpeedDialChild(
                child: Icon(Icons.arrow_upward, color: Colors.pinkAccent),
                backgroundColor: Colors.white,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _pedidosBloc.setFiltroPedido(SortCriterio.CONCLUIDOS_PRIMEIRO);
                }
              ),
          ],
        );
      case 2:
        //tela 2 (produtos)
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
          onPressed: (){
            showDialog(context: context,
                builder: (context) => EditarCategoriaDialog()
            );
          },
        );

    }
  }

}
