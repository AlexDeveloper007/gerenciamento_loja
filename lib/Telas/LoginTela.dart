import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/Blocs/LoginBloc.dart';
import 'package:gerenciamento_loja/Widgets/InputField.dart';

import 'HomeTela.dart';

class LoginTela extends StatefulWidget {
  @override
  _LoginTelaState createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outStatus.listen((status) {
      switch(status){
        case LoginStatus.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeTela())
          );
          break;
        case LoginStatus.FAILUSER:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Erro"),
            content: Text("Usuário ou senha inválidos!"),
          ));
          break;
        case LoginStatus.FAILPERMISSAO:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Erro"),
            content: Text("Você não possui os privilegios necessários"),
          ));
          break;
        case LoginStatus.LOADING:
        case LoginStatus.DADOS:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginStatus>(
        stream: _loginBloc.outStatus,
        initialData: LoginStatus.LOADING,
        builder: (context, snapshot) {
          //print(snapshot.data);
          switch(snapshot.data){
            case LoginStatus.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );
            case LoginStatus.FAILUSER:
            case LoginStatus.FAILPERMISSAO:
            case LoginStatus.SUCCESS:
            case LoginStatus.DADOS:
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.store_mall_directory,
                          color: Colors.pinkAccent,
                          size: 160,
                        ),
                        InputField(
                          icon: Icons.person_outline,
                          hint: "Usuário",
                          obscure: false,
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        InputField(
                          icon: Icons.lock_outline,
                          hint: "Senha",
                          obscure: true,
                          stream: _loginBloc.outSenha,
                          onChanged: _loginBloc.changeSenha,
                        ),
                        SizedBox(height: 32,),
                        StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 50,
                                child: RaisedButton(
                                  color: Colors.pinkAccent,
                                  child: Text("Entrar"),
                                  onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                  textColor: Colors.white,
                                  disabledColor: Colors.pinkAccent.withAlpha(140),
                                ),
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        }
      ),

    );
  }
}
