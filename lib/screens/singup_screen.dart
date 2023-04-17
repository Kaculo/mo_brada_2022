// ignore_for_file: non_constant_identifier_names

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
  final _pass2Controller = TextEditingController();
  final _addressController = TextEditingController();
  final _NIFController = TextEditingController();
  final _NotificationsController = TextEditingController();
  final _Money_BalanceController = TextEditingController();
  final _Loyalty_PointsController = TextEditingController();
  final _Active_PlanController = TextEditingController();
  final _Adress_BookController = TextEditingController();

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
        title: Text(" ${_loginBLoc.isLoggedIn() ? "Editar dados da conta" : "Criar conta" }"),

        centerTitle: true,
      ),
      body:
      StreamBuilder(
          stream: _loginBLoc.outState,
         initialData: LoginState.LOADING,
          //initialData: LoginState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
             case LoginState.SUCCESS:
               _GetTemporaryUserData();
               return showForm();
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
               return showForm();
                break;
            }

            //Só para retirar o aviso irritante
            return Container();
          }),
    );

  }
  Form showForm() {

    DateTime now = DateTime.now();
    var currentTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);

    return Form(
    key: _formKey,
    child: ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
                hintText: "*Nome próprio (1º nome)",
                label: Text("*Nome próprio (1º nome)")),
            validator: validatePrimeiroNome,
          //initialValue: _firstNameController.text
            //_loginBLoc.userData["first_name"]
      //  initialValue: _loginBLoc.isLoggedIn() ? "" :  _loginBLoc.userData["first_name"]
        ),
        const SizedBox(
          height: 16.0,
        ),

        TextFormField(
            controller: _LastNameController,
            decoration: const InputDecoration(
                hintText: "*Apelido (último nome)",
                label: Text("*Apelido (último nome)")
            ),
            validator: validateUltimoNome,
            //initialValue: _loginBLoc.isLoggedIn() ? "" : _loginBLoc.userData["last_name"]
        ),
        const SizedBox(
          height: 16.0,
        ),

        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
              hintText: "Insira o email",
              label: Text("*Email")
          ),
          validator: validateEmail,
          //initialValue: _loginBLoc.isLoggedIn() ? "" : _loginBLoc.userData["last_name"]
        ),
        const SizedBox(
          height: 16.0,
        ),
        TextFormField(
            controller: _NIFController,
            decoration: const InputDecoration(hintText: "NIF",
                label: Text("NIF")),
            validator: validateNIF
        ),
        const SizedBox(
          height: 16.0,
        ),
        TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(hintText: "*Endereço",
            label: Text("Endereço"),),
            validator: validateAdress
        ),
        const SizedBox(
          height: 16.0,
        ),

        !_loginBLoc.isLoggedIn() ?
        TextFormField(
            controller: _passController,
            decoration: const InputDecoration(hintText: "*Senha",
                label: Text("*Senha")),
            obscureText: true,
            validator: validatPassword
        ) : Container(),
        const SizedBox(
          height: 16.0,
        ),
        !_loginBLoc.isLoggedIn() ?
        TextFormField(
            controller: _pass2Controller,
            decoration: const InputDecoration(hintText: "*Repita a senha inserida",
                label: Text("Repita a senha inserida")),
            obscureText: true,
            validator: validatPassword2
        ) : Container(),

               _loginBLoc.isLoggedIn() ?
        Text(
          "usuário registado desde ${_loginBLoc.userData["creation_date"]}",
          style: const TextStyle(color: Colors.black45),
        ) : Container(),

        const SizedBox(
          height: 8.0,
        ),

        _loginBLoc.isLoggedIn() ?
        Text(
          "Última alteração foi em ${_loginBLoc.userData["last_update_date"]}",
          style: const TextStyle(color: Colors.black45),
        ) : Container(),
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
            child: Text(
              " ${_loginBLoc.isLoggedIn() ? "Guardar alterações" : "Criar conta" }",
              style: const TextStyle(fontSize: 18.0, color: Colors.white,),
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
                  "nif": _NIFController.text.toUpperCase(),
                  "creation_date": _loginBLoc.isLoggedIn() ? _loginBLoc.userData["creation_date"] : currentTime,
                  "last_update_date": currentTime,
                  "notifications": _NotificationsController.text,
                  "money_balance": _Money_BalanceController.text,
                  "loyalty_points": _Loyalty_PointsController.text,
                  "active_plan": _Active_PlanController.text,
                  "adress_book": _Adress_BookController.text,
                };
                _loginBLoc.isLoggedIn() ?
                _loginBLoc.updateUserData(
                    userData: userData,
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text(
                              "Dados do usuário actualizados com sucesso!"),
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
                              "Falha ao actualizar dados do usuário!"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 3),)
                      );
                    }) :  _loginBLoc.singUp(
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
  );}

  //Função que carrega os dados temporários do usuário
  void _GetTemporaryUserData() async {
        _firstNameController.text = _loginBLoc.userData["first_name"];
        _LastNameController.text = _loginBLoc.userData["last_name"];
        _emailController.text = _loginBLoc.userData["email"];
        _addressController.text = _loginBLoc.userData["address"];
        _NIFController.text = _loginBLoc.userData["nif"];
       _NotificationsController.text = _loginBLoc.userData["notifications"];
       _Money_BalanceController.text = _loginBLoc.userData["money_balance"];
     _Loyalty_PointsController.text = _loginBLoc.userData["loyalty_points"];
    _Active_PlanController.text = _loginBLoc.userData["active_plan"];
         _Adress_BookController.text = _loginBLoc.userData["adress_book"];
    }


}
