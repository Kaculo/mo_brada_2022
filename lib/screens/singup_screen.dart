import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/tabs/home_tab.dart';
import 'package:mo_brada_2022/validators/singup_validator.dart';


class SingUpScreen extends StatefulWidget {
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> with SingUpValidator {

  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();

  final _firstNameController = TextEditingController();
  final _LastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _NIFController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //Não podemos criar varios Widgets "Scaffold" com keys
  // diferentes dentro da mesma class, temos que criar uma
  //key Global para essas Scaffolds e usar em todas
  final _scaffoldKey = GlobalKey <ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body:
      StreamBuilder(
          stream: _loginBLoc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.SUCCESS:
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeTab())
                );
                break;
              case LoginState.FAIL:
                showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text("Erro"),
                          content: Text(
                              "Lamentamos, alguma coisa deu errado!"),

                        ));
                break;
              case LoginState.LOADING:
                return Center(child: CircularProgressIndicator());
                break;
              case LoginState.IDLE:
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                              hintText: "*Nome próprio (1º nome)"),
                          validator: validatePrimeiroNome
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _LastNameController,
                          decoration: InputDecoration(
                              hintText: "*Apelido (último nome)"),
                          validator: validateUltimoNome
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _NIFController,
                          decoration: InputDecoration(hintText: "NIF"),
                          validator: validateAdress
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(hintText: "*Endereço"),
                          validator: validateAdress
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "*E-mail"),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _passController,
                          decoration: InputDecoration(hintText: "*Senha"),
                          obscureText: true,
                          validator: validatPassword
                      ),
                      SizedBox(
                        height: 16.0,
                      ),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFBABF21),
                              disabledBackgroundColor: Theme
                                  .of(context)
                                  .primaryColor),
                          child: Text(
                            "Criar Conta",
                            style: TextStyle(fontSize: 18.0, color: Colors.white,),
                          ),

                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //POR QUESTÕES DE SEGURANÇA NÃO ARMAZENAMOS
                              //A SENHA JUNTO COM O USUÁRIO
                              Map<String, dynamic> userData = {
                                "first_name": _firstNameController.text,
                                "last_name": _firstNameController.text,
                                "email": _emailController.text,
                                "address": _addressController.text,
                                "nif": _NIFController.text
                              };
                              _loginBLoc.singUp(
                                  userData: userData,
                                  pass: _passController.text,
                                  onSuccess: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(
                                            "Usuário criado com sucesso!"),
                                          backgroundColor: Theme
                                              .of(context)
                                              .primaryColor,
                                          duration: Duration(seconds: 2),)
                                    );
                                    Future.delayed(Duration(seconds: 2)).then((
                                        _) {
                                      Navigator.of(context).pop();
                                    });
                                  },

                                  onFail: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(
                                            "Falha ao criar usuário!"),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 3),)
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
                break;
            }

            //Só para retirar o aviso irritante
            return Container();
          }),
    );
  }
}
