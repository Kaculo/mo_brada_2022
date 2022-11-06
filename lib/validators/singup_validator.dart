class SingUpValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Adicione imagens da Loja ";
    return null;
  }

  ///tODO: NÃO ACEITAR CARACTERES ESPECIAIS NO NOME
  String validatePrimeiroNome(String text){
    if(text.isEmpty) return "Insira o nome próprio";
    return null;
  }

  String validateUltimoNome(String text){
    if(text.isEmpty) return "Insira o nome o seu apelido (Último nome)!";
    return null;
  }

  String validateEmail(String text){
    if(!text.contains("@")) return "insira um e-mail válido!";
    return null;
  }

  String validatPassword(String text){
    if(!text.isEmpty) return "insira a palavra pass";
    if(text.length > 6) return "Senha invalida, deve conter pelo menos 4 caracteres";
    return null;
  }

  String validatePhone(String text){
    double phoneNubmer = double.tryParse(text);
    if(phoneNubmer != null){
      if(
      text.length < 9)
        return "Insira um número de telemovel válido";
    }
    return null;
  }

  String validateNIF(String text){
    ///if(text.isEmpty) return "Insira o seu NIF!"
    return null;
  }

  String validateAdress(String text){
    if(!text.isEmpty) return "insira o seu endereço";
    return null;
  }




}

