import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/screens/login_screen.dart';
import 'package:mo_brada_2022/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();

  @override
  Widget build(BuildContext context) {

    if(_loginBLoc.isLoggedIn()){

      getCurrentUser() {
        _loginBLoc.outCurrentUser.listen((state) async {
          String UserID;
          UserID = await currentuser.uid;
          return UserID;
        });
      }

      //Vamos obter todas as "orders" do user identificado acima
      //O FutureBuilder é do tipo "QuerySnapshot" porque
      //Vamos obter mais de um documenoto de uma colecção cmpleta e não
      //Apenas um documento
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("users")
        .doc(getCurrentUser()).collection("orders").get(),
        builder: (context, snapshot){
         if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          ); else{
            return ListView(
              children: snapshot.data.docs
              .map((doc) => OrderTile(doc.id)).toList().reversed.toList(),
            ) ;        }
        },
      );

    } else {

      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.view_list, size: 80.0,
              color: Theme
                  .of(context)
                  .primaryColor,),
            SizedBox(height: 16.0,),
            Text("Faça o Login para acompanhar os seus pedidos!",
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 16.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBABF21),
                  disabledBackgroundColor: Theme
                      .of(context)
                      .primaryColor),
              child: Text('Entrar', style: TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )
          ],
        ),
      );
    }

  }
}
