import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class UserModel extends Model {
  //Criando uma instáncia do FirebaseAuth, para
  //não estar a repetir "FirebaseAuth.instance"
  FirebaseAuth _auth = FirebaseAuth.instance;

  //variavel para armazenar o usuário no FirebaseUser
  User? firebaseUser;

  //Map Dinámico para armazenar os dados do usuário
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  //Um método estático é um metodo da classe e não do Objecto
  //ESTA FUNÇÃO VAI NOS PERMITIR DECLARAR WIDGETS
  //DEPENDENTES DO NOSSO MODEL, SEM TER QUE DECLARAR
  // UM SCOPED DESCENDENT
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

//CARREGANDO O USER AO ABRIR O APP
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();

  }

  void singUp(
      {
      //"@required" serve para obrigrar o usuário a inserir este
      //parametro, mesmo que este esteja definido como opcional
      required Map<String, dynamic> userData,
      required String pass,

      //VoidCAllback é uma função utilizada apenas
      //dentro do ambiente de declaração, neste caso,
      //a função.
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    //TENTANDO CRIAR O USUÁRIO
    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass)
        .then((user) async {
      //SALVANDO USUÁRIO CRIADO
      firebaseUser = _auth.currentUser!;
      //SALVANDO DADOS DO USUÁRIO CRIADO
      await _saveUserData(userData);

      //CASO O USUÁRIO SEJA CRIADO COM SUCESSO
      onSuccess();
      isLoading = false;

      notifyListeners();
    }).catchError((e) {
      print("o erro na criação do usuário foi é: $e");
      //CASO HAJA ERRO  NA CRIAÇÃO DO USUÁRIO
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void singIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    //notifyListeners() actualiza tudo que está dentro do
    // ScopedModelDescendant utilizando o nosso model
    notifyListeners();

    //TENTANDO FAZER LOGIN
   _auth.signInWithEmailAndPassword(email: email, password: pass).
   then((user) async{
    //CASO TENHA SUCESSO
     firebaseUser = _auth.currentUser!;
     await _loadCurrentUser();
     onSuccess();
     isLoading = false;
    notifyListeners();

   }).catchError((e){
     //CASO DÊ ERRO AO LOGAR
     onFail();
     isLoading = false;
     notifyListeners();

   });
  }

  void singOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email) {
  _auth.sendPasswordResetEmail(email: email);

  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //Função que grava os dados do usuário
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {

    this.userData = userData;

    //Salvando dados do suário na base de dados para poder
    //utilizar mais tarde
    await FirebaseFirestore.instance.collection("users").
    doc(firebaseUser?.uid).set(userData);
        //Salvando dados do usuário na base de dados
        //num documento com o nome correspondente a Id do
        // nosso usuário

    print("Os usuários salvos são: \n");
    print(FirebaseFirestore.instance.collection("users").get());
  }

  //Função que carrega os dados usuário actual
  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser;
    if(firebaseUser != null){

  //Se Carregando dados do User
      if(userData["name"] == null){
        DocumentSnapshot docUser =
        await FirebaseFirestore.instance.collection("users").
        doc(firebaseUser?.uid).get();
        userData = docUser.data() as Map<String, dynamic>;
      }
    }
    notifyListeners();
  }
}
