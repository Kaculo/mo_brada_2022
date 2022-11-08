import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/screens/category_screen.dart';

class products_category_tile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  products_category_tile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //É o icone ou widget que fica na esquerda de cada Row ListTile
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data()!['icon']),
      ),
      title: Text(
          snapshot.data()!['category_title']),
      //trailing - É o elemento que fica no final de cada Row da ListTile
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        //Quando clicar em uma das categorias de produtos, vamos para a pagina
        //especifica da categoria selecionada
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => CategoryScreen(snapshot))));
      },
    );
  }
}
