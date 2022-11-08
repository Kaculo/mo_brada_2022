import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/screens/singup_screen.dart';
import 'package:mo_brada_2022/validators/loging_validators.dart';
import 'package:mo_brada_2022/widgets/inpu_field.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginValidators {


  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey <ScaffoldState>();
  final _loginBloc = BlocProvider.getBloc<LoginBLoc>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white
              ),
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15.0),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SingUpScreen()));
              },
            )
          ],
        ),
        body:
        StreamBuilder(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot){
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.red[700]),
                  ),
                );
              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return BlocProvider(
                    dependencies: [],
              blocs: [Bloc ((context) => LoginBLoc())],
              child:
              Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  InputField(
                    icon: Icons.person_outline,
                    hint: "Utilizador",
                    obscure: false,
                    stream: _loginBloc.outEmail,
                    onChanged: _loginBloc.changeEmail,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  InputField(
                    icon: Icons.lock_outline,
                    hint: "Senha",
                    obscure: true,
                    stream: _loginBloc.outPassword,
                    onChanged: _loginBloc.changePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.red[700]
                      ),
                      onPressed: () {
                        if (_loginBloc.outEmail.isEmpty != null)
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Insira seu e-mail para recuperar senha!"),
                                backgroundColor: Colors.redAccent,
                                duration:  Duration(seconds: 3),)
                          );
                        else {
                          _loginBloc.recoverPass(_loginBloc.getEml);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Confira o seu e-mail!"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration:  Duration(seconds: 3),)
                          );}
                      },
                      child: Text(
                        "Esqueci a minha password!",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBABF21),
                          disabledBackgroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      onPressed: () {
                        ///todo: if(_formKey.currentState.validate()){}
                        _loginBloc.singIn(
                            email: _loginBloc.getEml,
                            pass: _loginBloc.getPss,
                            onSuccess: _onSuccess,
                            onFail: _onFail);

                        print("Botão entrar Apertado");
                      },
                    ),
                  )
                ],
              ),
            ));}

                    //Só para retirar o aviso irritante
                    return Container();
          },
        )
    );
  }

  void _onSuccess() {

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();});

  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao Entrar!"),
          backgroundColor: Colors.redAccent,
          duration:  Duration(seconds: 3),)
    );
  }

}
