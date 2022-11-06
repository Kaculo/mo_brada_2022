import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'package:mo_brada_2022/screens/stores_home_screen.dart';

import '../hometoptabs.dart';
import 'home_screen.dart';
import 'home_screen2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
/*
* decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(
                  255,
                  211,
                  118,
                  130,
                ),
                Color.fromARGB(
                  255,
                  253,
                  181,
                  168,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),*/

Color PrimaryColor = Color(0xff109618);

class _HomePageState extends State<HomePage> {
  late List<String> kEnglishWords;

  //_MySearchDelegate _delegate;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: _GooglePlayAppBar(),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 6.0,
              onTap: (index) {
               /**trocava a prymari color com base no item selecionado**/
                setState(() {
                  switch (index) {
                    case 0:
                      PrimaryColor = Color.fromRGBO(
                          31,
                          130,
                          191,
                          1
                      );
                      break;
                    case 1:
                      PrimaryColor = Color(0xff3f51b5);
                      break;
                    case 2:
                      PrimaryColor = Color.fromRGBO(
                          242,
                          70,
                          7,
                          1
                      );
                      break;
                    case 3:
                      PrimaryColor = Color(0xff9c27b0);
                      break;
                    case 4:
                      PrimaryColor = Color(0xff2196f3);
                      break;
                    default:
                  }
                });
              },
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: Text(
                      'HOME',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'LOJAS',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'RESTAURANTES',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'SERVIÇOS',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'MUSIC',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomeScreen(),
              Store_Home_Screen("loja"),
              Store_Home_Screen("restaurante"),
              HomeTopTabs(0xffff5722),
              HomeTopTabs(0xffff5722),
            ],
          ),
        ),
    );
  }

  Widget _GooglePlayAppBar() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(FontAwesomeIcons.bars),
              onPressed: () {  },
            ),
          ),
          Container(
            child: Text(
              'Pesquisar Loja ou Produto',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.microphone,
                  color: Colors.blueGrey,
                ),
                onPressed: null),
          ),
        ],
      ),
    );
  }
}
