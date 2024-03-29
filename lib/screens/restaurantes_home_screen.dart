import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/data/product_data.dart';
import 'package:mo_brada_2022/data/store_data.dart';
import 'package:mo_brada_2022/tiles/Store_List_Tile.dart';
import 'package:mo_brada_2022/tiles/product_tile.dart';


//ESTE SCREEN MOSTRA TODAS LOJAS EXISTENTES NA APP
class Restaurantes_Home_Screen extends StatelessWidget {


  /*final DocumentSnapshot snapshot;

  Store_Home_Screen(this.snapshot);*/
 // Text(snapshot.data()["title"])

// Create a CollectionReference called users that references the firestore collection
  CollectionReference fb_lojas = FirebaseFirestore.instance.collection('lojas');
FirebaseFirestore Firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            //O SnapShot chamado aqui é o da Categoria
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Pequisar",
                    hintStyle: TextStyle(color: Colors.white),
                    icon: Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none
                ),
                //onChanged: _userBloc.onChangedSearch,
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
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
            future: Firestore.collection('lojas').where('type', isEqualTo: 'restaurante').get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    //.builder - é adicionado para que os items sejam carregados a medida que o ecran é deslizado.
                    GridView.builder(
                        padding: const EdgeInsets.all(4.0),
                        //gridDelegate - Quantos Intems terá a Grid
                        //e qual será o espaçamento entre eles.
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          StoreData data = StoreData.fromDocument(
                              snapshot.data!.docs[index]);

                          //PEGANDO A CATEGORIA DO PRODUTO
                          //Aqui utilizamos "this.snapshot" para chamar o
                          //Snapshot local que é o de cada producto da catégoria
                          //todo:Gerir quando separar categorias de Lojas (Lojas, Restaurantes e Serviços)
                          // data.store_category = snapshot.data.docs.;

                          return Expanded(child: Store_List_Tile("grid", data));
                        }),
                    ListView.builder(
                        padding: const EdgeInsets.all(4.0),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          StoreData data = StoreData.fromDocument(
                              snapshot.data!.docs[index]);
                          //todo: configurar quando separar as lojas por categoria
                          //data.category = this.snapshot.documentID;
                          return Store_List_Tile(
                              "list",data);
                        })
                  ],
                );
              }
            },
          )),
    );
  }
}
