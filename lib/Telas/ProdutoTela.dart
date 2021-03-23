import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/ProdutoBloc.dart';
import 'package:gerenciamento_loja/Validadores/ProdutoValidator.dart';
import 'package:gerenciamento_loja/Widgets/ImagensWidget.dart';
import 'package:gerenciamento_loja/Widgets/TamanhoProduto.dart';

class ProdutoTela extends StatefulWidget {

  final String idCategoria;
  final DocumentSnapshot produto;



  ProdutoTela({this.idCategoria, this.produto});
  @override
  _ProdutoTelaState createState() => _ProdutoTelaState(idCategoria, produto);
}

class _ProdutoTelaState extends State<ProdutoTela> with ProdutoValidator{

  final ProdutoBloc _produtoBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ProdutoTelaState(String idCategoria, DocumentSnapshot produto) :
  _produtoBloc = ProdutoBloc(idCategoria: idCategoria, produto: produto);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16
    );

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
          stream: _produtoBloc.outCreated,
          initialData: false,
          builder: (context, snapshot) {
            return Text(snapshot.data ? "Editar Produto" : "Criar Produto" );
          }
        ),
        actions: [
          StreamBuilder<bool>(
            stream: _produtoBloc.outCreated,
            initialData: false,
            builder: (context, snapshot){
              if(snapshot.data == true){
                return StreamBuilder<bool>(
                    stream: _produtoBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data ? null : (){ //verifica se está carregando
                          _produtoBloc.deletarProduto();
                          Navigator.of(context).pop();
                        },
                      );
                    }
                );
              }else{
                return Container();
              }
            },
          ),
          StreamBuilder<bool>(
            stream: _produtoBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                  icon: Icon(Icons.save),
                  onPressed: snapshot.data ? null : salvarProduto, //verifica se está carregando
              );
            }
          )
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _produtoBloc.outData,
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Container();
                } else if(snapshot.data.length == 0){return Container(child: CircularProgressIndicator(),);}

                else{
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(
                        "Imagens",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                        ),
                      ),
                      ImagensWidget(
                        context: context,
                        initialValue: snapshot.data["imagens"] != null ? snapshot.data["imagens"]:[] ,
                        onSaved: _produtoBloc.salvarImagens,
                        validator: validarImagens,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["titulo"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: _produtoBloc.salvarTitulo,
                        validator: validarTitulo,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["descricao"],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: _produtoBloc.salvarDescricao,
                        validator: validarDescricao,
                      ),
                      TextFormField(
                        initialValue: snapshot.data["preco"]?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onSaved: _produtoBloc.salvarPreco,
                        validator: validarPreco,
                      ),
                      SizedBox(height: 16,),
                      Text(
                        "Tamanhos",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                        ),
                      ),
                      TamanhoProduto(
                        context: context,
                        initialValue: snapshot.data["tamanhos"] ?? [],
                        onSaved: _produtoBloc.salvarTamanhos,
                        validator: (tam){
                          if(tam.isEmpty){
                            return "Adicione um tamanho";
                          }else{
                            return null;
                          }
                        },
                      ),

                    ],
                  );
                }
              }
            ),

          ),
          //==================Quando estiver salvando bloqueia a tela===========
          StreamBuilder<bool>(
              stream: _produtoBloc.outLoading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  //se estiver carregando vai ignorar o ponteiro
                  //se nao estiver carregando ele não ignora o ponteiro
                  ignoring: !snapshot.data,
                  child: Container(
                    color: snapshot.data? Colors.black54 : Colors.transparent,
                  ),
                );
              }
          )
        ],
      ),
    );
  }

  void salvarProduto() async{
    if( _formKey.currentState.validate() ){
      _formKey.currentState.save();
      
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text(
              "Salvando produto...",
              style: TextStyle(color: Colors.white),
            ),
          duration: Duration(minutes: 1),
          backgroundColor: Colors.pinkAccent,
        ),
      );

      bool sucesso = await _produtoBloc.salvarProduto();

      //fechar snackbar
      _scaffoldKey.currentState.removeCurrentSnackBar();

      //nova snack
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            sucesso ? "Produto salvo!" : "Erro ao salvar produto!",
            style: TextStyle(color: Colors.white),
          ),
          //duration: Duration(minutes: 1),
          backgroundColor: sucesso ? Colors.green : Colors.red,
        ),
      );
    }
  }


}
