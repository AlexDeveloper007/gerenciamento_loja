import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciamento_loja/Validadores/LoginValidador.dart';
import 'package:rxdart/rxdart.dart';

enum LoginStatus {DADOS, LOADING, SUCCESS, FAILUSER, FAILPERMISSAO}

class LoginBloc extends BlocBase with LoginValidador {

  final _emailController = BehaviorSubject<String>();
  final _senhaController = BehaviorSubject<String>();
  final _statusController = BehaviorSubject<LoginStatus>();

  Stream<String> get outEmail => _emailController.stream.transform(validarEmail);
  Stream<String> get outSenha => _senhaController.stream.transform(validarSenha);
  Stream<LoginStatus> get outStatus => _statusController.stream;
  
  Stream<bool> get outSubmitValid => Observable.combineLatest2(
    //se tiver dados (validados) nas duas streams
      outEmail,
      outSenha,
          (a, b) => true
  );
  
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeSenha => _senhaController.sink.add;

  StreamSubscription _streamSubscription;

  LoginBloc(){
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async{
      if(user != null){
        if(await verificarPermissoes(user)){
          _statusController.add(LoginStatus.SUCCESS);
        }else{
          FirebaseAuth.instance.signOut();
          _statusController.add(LoginStatus.FAILPERMISSAO);
        }
      }else{
        _statusController.add(LoginStatus.DADOS);
      }
    });
  }

  void submit(){
    final email = _emailController.value;
    final senha = _senhaController.value;

    _statusController.add(LoginStatus.LOADING);

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: email,
        password: senha
    ).catchError( (erro) {
      _statusController.add(LoginStatus.FAILUSER);
    });
  }

  Future<bool> verificarPermissoes(FirebaseUser user) async{
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc){

      if(doc.data != null){
        return true;
      }else{
        return false;
      }

    }).catchError( (erro) {
      return false;
    });

  }



  @override
  void dispose() {
    _emailController.close();
    _senhaController.close();
    _statusController.close();

    _streamSubscription.cancel();

  }

}
