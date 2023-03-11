import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        title: const Text("Criar Conta"),
        centerTitle: true,
      ),
      body:
      StreamBuilder(
          stream: _loginBLoc.outState,
         // initialData: LoginState.LOADING,
          initialData: LoginState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
             case LoginState.SUCCESS:
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeTab())
                  );
                });
                break;
              case LoginState.FAIL:
                showDialog(
                    context: context,
                    builder: (context) =>
                        const AlertDialog(
                          title: Text("Erro"),
                          content: Text(
                              "Lamentamos, alguma coisa deu errado!"),
                        ));
                break;
              case LoginState.LOADING:
                return const Center(child: CircularProgressIndicator());
                break;
              case LoginState.IDLE:
                return Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                              hintText: "*Nome próprio (1º nome)"),
                          validator: validatePrimeiroNome
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _LastNameController,
                          decoration: const InputDecoration(
                              hintText: "*Apelido (último nome)"),
                          validator: validateUltimoNome
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _NIFController,
                          decoration: const InputDecoration(hintText: "NIF"),
                          validator: validateNIF
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(hintText: "*Endereço"),
                          validator: validateAdress
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(hintText: "*E-mail"),
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                          controller: _passController,
                          decoration: const InputDecoration(hintText: "*Senha"),
                          obscureText: true,
                          validator: validatPassword
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBABF21),
                              disabledBackgroundColor: Theme
                                  .of(context)
                                  .primaryColor),
                          child: const Text(
                            "Criar Conta",
                            style: TextStyle(fontSize: 18.0, color: Colors.white,),
                          ),

                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //POR QUESTÕES DE SEGURANÇA NÃO ARMAZENAMOS
                              //A SENHA JUNTO COM O USUÁRIO
                              Map<String, dynamic> userData = {
                                "first_name": _firstNameController.text,
                                "last_name": _LastNameController.text,
                                "email": _emailController.text,
                                "address": _addressController.text,
                                "nif": _NIFController.text
                              };
                              _loginBLoc.singUp(
                                  userData: userData,
                                  pass: _passController.text,
                                  onSuccess: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: const Text(
                                            "Usuário criado com sucesso!"),
                                          backgroundColor: Theme
                                              .of(context)
                                              .primaryColor,
                                          duration: const Duration(seconds: 2),)
                                    );
                                    Future.delayed(const Duration(seconds: 2)).then((
                                        _) {
                                      Navigator.of(context).pop();
                                    });
                                  },

                                  onFail: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text(
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
