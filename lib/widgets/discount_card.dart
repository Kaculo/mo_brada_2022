import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/cart_bloc.dart';

class DiscountCard extends StatelessWidget {

  final _cartBloc = BlocProvider.getBloc<CartBloc>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          title: Text("Cupom de Desconto",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.w500,
                color: Colors.grey[700]),),
          leading: Icon(Icons.card_giftcard),
          trailing: Icon(Icons.add),
          children: <Widget>[
      Padding(
      padding: EdgeInsets.all(8.0),
      child: BlocProvider(
        dependencies: [],
        blocs: [Bloc((context) => CartBloc())],
        child: TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Digite o código do seu cupom"
          ),

          initialValue: _cartBloc.couponCode ?? "",
          onFieldSubmitted: (text) {
            FirebaseFirestore.instance.collection("coupons").doc(text).get()
                .then((docSnap) {
              //SE O CÓDIGO DO CUPOM INSERIDO ESTIVER CERTO
              if (docSnap.data != null) {
                _cartBloc..setCoupom(text, docSnap.data()["percent"]);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(
                      "Desconto de ${docSnap.data()["percent"]}% aplicado!"),
                  backgroundColor: Theme.of(context).primaryColor,));
              }
              //CASO O CUPON NÃO SEJA VÁLIDO
              else {
              _cartBloc.setCoupom(null, 0);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("O Código do Cupom inserido não é válido!"),
              backgroundColor: Colors.redAccent));
              }
            });
          },
        ),
      )
      )],
    ),);
  }
}
