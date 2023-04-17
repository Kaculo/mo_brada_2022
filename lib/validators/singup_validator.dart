import 'package:bloc_pattern/bloc_pattern.dart';

import '../blocs/login_bloc.dart';

class SingUpValidator {

  var _s1;

  String? validateImages(List images){
    if(images.isEmpty) return "Adicione imagens da Loja ";
    return null;
  }

  ///tODO: NÃO ACEITAR CARACTERES ESPECIAIS NO NOME
  String? validatePrimeiroNome(String? text){
    if(text!.isEmpty) return "Insira o nome próprio";
    return null;
  }

  String? validateUltimoNome(String? text){
    if(text!.isEmpty) return "Insira o nome o seu apelido (Último nome)!";
    return null;
  }

  String? validateEmail(String? text){
    if(!text!.contains("@")) return "insira um e-mail válido!";
    return null;
  }

  String? validatPassword(String? text){
    if(!text!.isNotEmpty) return "insira a palavra pass";
    if(text.length < 8) {
      return "Senha invalida, deve conter pelo menos 8 caracteres!";}
    _s1 = text;
    return null;
  }

  String? validatPassword2(String? text){
    if(text != _s1) return "As senhas inseridas são diferentes!";
     return null;
  }

  String? validatePhone(String text){
    double? phoneNubmer = double.tryParse(text);
    if(phoneNubmer != null){
      if(
      text.length < 9)
        return "Insira um número de telemovel válido!";
    }
    return null;
  }

  String? validateNIF(String? text){
    ///if(text.isEmpty) return "Insira o seu NIF!"
    return null;
  }

  String? validateAdress(String? text){
    if(text!.isEmpty) return "insira o seu endereço";
    return null;
  }


}

