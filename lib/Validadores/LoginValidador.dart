import 'dart:async';

class LoginValidador {

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if(email.contains("@")){
        sink.add(email);
      }else{
        sink.addError("Insira um e-mail válido");
      }
    }
  );

  final validarSenha = StreamTransformer<String, String>.fromHandlers(
    handleData: (senha, sink){
      if(senha.isEmpty || senha.length < 6){
        sink.addError("Digite uma senha mais forte!");
      }else{
        sink.add(senha);
      }
    }
  );

}