import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mo_brada_2022/validators/loging_validators.dart';
import 'package:rxdart/rxdart.dart';

//Todo: Saber exactamente o que é um enumerador
/// ESTADOS DO PROCESSO DE LOGIN*
enum LoginState {IDLE, LOADING, SUCCESS, FAIL}

User? currentuser;
User? firebaseUser;


//onde: IDLE: usuario está a apenas a inserir os dados,
//LOADING: Usuário os dados inseridos estão a ser processados
//SUCCESS: Os dados foram processados com sucesso
//FAIL: Houve erro ao processar os dados.

class LoginBLoc extends BlocBase with LoginValidators {
  //OBS: colocamos "with LoginValidators" porque os dados que
  //vamos buscar no LoginValidators são final

  //Criando uma instáncia do FirebaseAuth, para
  //não estar a repetir "FirebaseAuth.instance"
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Map Dinámico para armazenar os dados do usuário
  Map<String, dynamic> userData = Map();

  //Map que armazena os dados do usuário não gravados
  Map<String, dynamic> unsavedUserData = {
    "first_name": "",
    "last_name": "",
    "email": "",
    "address": "",
    "nif": "",
  };


  //CARREGANDO O USER AO ABRIR O APP
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  bool isLoggedIn() {
    print("*************O email do user é ${userData.isEmpty}");
    return currentuser != null;
  }

  void singUp({
    //"@required" serve para obrigrar o usuário a inserir este
    //parametro, mesmo que este esteja definido como opcional
    required Map<String, dynamic> userData,
    required String pass,

    //VoidCAllback é uma função utilizada apenas
    //dentro do ambiente de declaração, neste caso,
    //a função.
    required VoidCallback onSuccess,
    required VoidCallback onFail}) {
    //TENTANDO CRIAR O USUÁRIO
    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass)
        .then((user) async {
      //SALVANDO USUÁRIO CRIADO
      currentuser = _auth.currentUser;
      //SALVANDO DADOS DO USUÁRIO CRIADO
      await _saveUserData(userData);

      //CASO O USUÁRIO SEJA CRIADO COM SUCESSO
      onSuccess();

      /// isLoading = false;

      notifyListeners();
    }).catchError((e) {
      print("o erro na criação do usuário foi é: $e");
      //CASO HAJA ERRO  NA CRIAÇÃO DO USUÁRIO
      onFail();

      ///isLoading = false;
      notifyListeners();
    });
  }


  void updateUserData({
    required Map<String, dynamic> userData,
    //VoidCAllback é uma função utilizada apenas
    //dentro do ambiente de declaração, neste caso,
    //a função.
    required VoidCallback onSuccess,
    required VoidCallback onFail}) {
    //TENTANDO CRIAR O USUÁRIO
    _auth.currentUser?.getIdToken().then((user) async {
      //SALVANDO USUÁRIO CRIADO
      currentuser = _auth.currentUser;
      //SALVANDO DADOS DO USUÁRIO CRIADO
      await _saveUserData(userData);

      //CASO O USUÁRIO SEJA CRIADO COM SUCESSO
      onSuccess();

      /// isLoading = false;

      notifyListeners();
    }).catchError((e) {
      print("o erro na criação do usuário foi é: $e");
      //CASO HAJA ERRO  NA CRIAÇÃO DO USUÁRIO
      onFail();

      ///isLoading = false;
      notifyListeners();
    });
  }


  //Função que grava os dados do usuário
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    //Salvando dados do suário na base de dados para poder
    //utilizar mais tarde
    await FirebaseFirestore.instance.collection("users").
    doc(currentuser?.uid).set(userData);
    //Salvando dados do usuário na base de dados
    //num documento com o nome correspondente a Id do
    // nosso usuário

    print("Os usuários salvos são: \n");
    print(FirebaseFirestore.instance.collection("users").get());
  }

  //Função que carrega os dados usuário actual
  Future<Null> _loadCurrentUser() async {
    currentuser ??= await _auth.currentUser;
    if (currentuser != null) {
      //Se Carregando dados do User
      if (userData["first_name"] == null) {
        DocumentSnapshot docUser =
        await FirebaseFirestore.instance.collection("users").
        doc(currentuser?.uid).get();
        userData = docUser.data() as Map<String, dynamic>;
        print("************* Ao carregar o userDAta estes estava ${userData.isEmpty}");
      }
    }
  }


  /**CRIANDO CONTROLADORES PARA OS TEXTFIELDS DA LOGIN_SCREEN**/
  /// ***************************.*****************************
  //O controlador é do tipo do conteudo que vai passar por ele
  //nete caso como é para o email, então é String
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();


  // _stateController vai controlar em q estado está o login e
  // reportar essa informação para p.ex mudar a tela de login
  // LoginState é o tipo do enumeradr que criamos
  final _stateController = BehaviorSubject<LoginState>();

  final _currentUserController = BehaviorSubject<User?>();

  /**CRIANDO AS STREAMS DOS CONTROLADORES CRIADOS**/
  /// ***************************.*****************************
  //Stream é por onde sai o conteudo que passa pelo controlador.

  Stream <String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  String get getEml =>
      _emailController.value;

  String get getPss =>
      _passwordController.value;

  LoginState get getLoginState =>
      _stateController.value;

  Stream <String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream <bool> get outSubmitValid =>
      Rx.combineLatest2(
          outEmail, outPassword, (a, b) => true);

  Stream <LoginState> get outState => _stateController.stream;

  Stream <User?> get outCurrentUser => _currentUserController.stream;

  //Tudo que é passado para essas funções change, vai directo para o devido controller
  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription? _streamSubscription;

  //Alocamos a LoginBLoc() em uma varialvel streamSubscription para podermos
  //cancelar no "Dispose do bloc", senão iria rodar infinitamente.

  //Construtor do LoginBLoc que controla se o usuário está logado ou não
  LoginBLoc() {
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
          if (user != null) {
            if (await verifyPrivileges(user)) {
              //Se a "verifyPrivileges" retorna true para o usuario
              //é porq ele é administrador
              currentuser = FirebaseAuth.instance.currentUser;
              _currentUserController.add(currentuser);
              _stateController.add(LoginState.SUCCESS);
              await _loadCurrentUser();
            } else {
              //se "verifyPrivileges" retorna false
              //é porq ele não é administrador
              //Então não tem porq ficar logado.
              FirebaseAuth.instance.signOut();
              _stateController.add(LoginState.FAIL);
            }
          } else {
            _stateController.add(LoginState.IDLE);
          }
        });
  }

  void singIn(
      {required String email,
        required String pass,
        required VoidCallback onSuccess,
        required VoidCallback onFail}) async {
    _stateController.add(LoginState.LOADING);
    //notifyListeners() actualiza tudo que está dentro do
    // ScopedModelDescendant utilizando o nosso model


    //TENTANDO FAZER LOGIN
    _auth.signInWithEmailAndPassword(email: email, password: pass).
    then((user) async{
      //CASO TENHA SUCESSO
      currentuser = _auth.currentUser;
      await _loadCurrentUser();
      onSuccess();
      _stateController.add(LoginState.SUCCESS);


    }).catchError((e){
      print("XXXXXXXXXXXXXXXX O erro na tentativa de loging foi: $e");
      //CASO DÊ ERRO AO LOGAR
      onFail();
      if (!_stateController.isClosed)
        _stateController.add(LoginState.FAIL);


    });
  }

  void singOut() async {
    await _auth.signOut();
    userData = Map();
    currentuser = null;
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);

  }

  void submit() {
    //Controller.value retorna o ultimo valor do controlador
    final email = _emailController.value;
    final password = _passwordController.value;
    final currentUser2 = _currentUserController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).catchError((e) {
      _stateController.add(LoginState.FAIL);

      outState.listen((state) {
        if (state == LoginState.SUCCESS)
          currentuser = FirebaseAuth.instance.currentUser;
        _currentUserController.add(currentuser);
      });
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance.collection('admins')
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        //Se o User consta na collection de admins
        return true;
      } else {
        //Se não consta na collection de admins
        return false;
      }
    })
    //Caso nem tenha acesso a colecção "admins"
        .catchError((e) {
      return false;
    });
  }

  @override
  void dispose() {
    /**Todos Controladores tm que ser fechado**/
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _currentUserController.close();
    _streamSubscription?.cancel();
  }
}

