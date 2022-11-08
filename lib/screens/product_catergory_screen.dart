import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/data/store_data.dart';
import 'package:mo_brada_2022/tabs/products_tab.dart';
import 'package:mo_brada_2022/tabs/store_products_Tab.dart';
import 'package:mo_brada_2022/tiles/category_tile.dart';
import 'package:mo_brada_2022/widgets/cart_button.dart';

/**aparece no category screen**/

class Product_Category_Screen extends StatelessWidget {
  final StoreData store;

  Product_Category_Screen(this.store);

  @override
  Widget build(BuildContext context) {
    //FutureBuilder porq os dados q estão no FireBase não vêm Instaneamente
    return  Scaffold(
      appBar: AppBar(
        title: Text(store.title),
        centerTitle: true,
      ),
      //drawer: CustomDrawer(_pageController),
      body: Store_products_tab(store),
      floatingActionButton: CartButton(),
    );

    /*FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('lojas')
            .doc('ola_food')
            .collection('Categoria_de_produtos').get(),
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
        });*/
  }
}
