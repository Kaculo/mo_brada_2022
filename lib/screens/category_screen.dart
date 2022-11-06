import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/data/product_data.dart';
import 'package:mo_brada_2022/tiles/product_tile.dart';


//ESTE SCREEN MOSTRA OS ITEMS DA CATEGORIA SELECIONADA
//NO SCREEN ANTERIOR ANTERIOR
class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            //O SnapShot chamado aqui é o da Categoria
            title: (Text(snapshot.data()!["category_title"])),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          //TabBarView -  É para colocar o que
          body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('lojas')
                .doc("ola_food")
                .collection("Categoria_de_produtos")
                .doc(snapshot.id)
                .collection("items")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    //.builder - é adicionado para que os items sejam carregados a medida que o ecran é deslizado.
                    GridView.builder(
                        padding: EdgeInsets.all(4.0),
                        //gridDelegate - Quantos Intems terá a Grid
                        //e qual será o espaçamento entre eles.
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data?.docs[index]!);

                          //PEGANDO A CATEGORIA DO PRODUTO
                          //Aqui utilizamos "this.snapshot" para chamar o
                          //Snapshot local que é o de cada producto da catégoria
                          data.category = this.snapshot.id;

                          return ProductTile("grid", data);
                        }),
                    ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data?.docs[index]!);
                          data.category = this.snapshot.id;
                          return ProductTile(
                              "list",data);
                        })
                  ],
                );
            },
          )),
    );
  }
}
