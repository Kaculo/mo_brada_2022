import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/tiles/category_tile.dart';

/**aparece no category screen**/

class ProductsTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //FutureBuilder porq os dados q estão no FireBase não vêm Instaneamente
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('products')
            .get(),
        builder: (context, snapeshot) {
          //Se o snapeshot estiver vazio, quer dizer que os dados estão a ser carregados
          //Então mostrar Circulo de Progresso
          if (!snapeshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            var dividedTiles = ListTile.divideTiles(
                    tiles:
                        //Esta Função pega cada documento dentro do snapshot,
                        //transforma em "CategoryTile" e transforma conjunto
                        // de itens retornados em uma Lista
                        snapeshot.data?.docs.map((doc) {
                      return CategoryTile(doc);
                    }).toList(),
                    color: Colors.grey[500])
                .toList();
            return ListView(
              children: dividedTiles,
            );
          }
        });
  }
}
