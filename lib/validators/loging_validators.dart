import 'dart:async';

class LoginValidators {

  //Validators fazem a validação dos dados que passam pelo controller
  //tem que indicar que tipo de dados vai entrar no validator que tipo
  // de dados este vai retornar por "<String, String>"

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains("@")){
        sink.add(email);
      } else {
        sink.addError("Insira um e-mail válido");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if(password.length > 4){
          sink.add(password);
        } else {
          sink.addError("Senha invalida, deve conter pelo menos 4 caracteres");
        }

      }
  );
}