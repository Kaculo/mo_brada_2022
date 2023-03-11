import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Função que cria fundo com efeito gradiente degrade
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(
                255,
                211,
                47,
                47,
              ),
              Color.fromRGBO(
                  186,
                  191,
                  33,
                  1.0
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            //Dentro do SiverAppbar, todos widgits têm que ser do tipo silver
            const SliverAppBar(
              floating: true,
              //snap: faz com que o elemento desaparece
              // a medida que for rolando a ScrollView.
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Em destaque'),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .get(),
                builder: (context, snapshot) {
                  //se o snapshot não possui dados, apresentado a barra de progresso!
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return
                        //SliverStaggeredGrid - é o plugn que permite criar GridView com tamanhos diferentes
                        StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      //Obtendo cada um dos documentos do Firebase com as dimensões individuais,
                      //convertendo essas dimenções para o tipo
                      // para colocar na GridView
                      children: snapshot.data!.docs.map((doc) {
                        var teste = snapshot.data!.docs.toString();

                           return StaggeredGrid.count(
                          mainAxisSpacing: (doc.data()['x']).toDouble(),
                          crossAxisCount: (doc.data()['y']),
                          children: snapshot.data!.docs.map((doc) {

                            //FadeInImage - Armazena a Image e mostra a imagem
                            //Com efeito FadIn
                            return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.data()["image"],
                              fit: BoxFit.cover,
                            );
                          }).toList(),);
                      }).toList(),

                    );
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
