import 'package:flutter/material.dart';

import 'package:mo_brada_2022/screens/home_screen2.dart';
import 'package:mo_brada_2022/screens/restaurantes_home_screen.dart';
import 'package:mo_brada_2022/screens/stores_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        bottomNavigationBar:
            ///Colocamos o "BottomNavigationBar" dentro do Theme
            /// porque queremos editar alguns itens no tema principal.
            Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.red[700],
              primaryColor: Colors.yellow[700],
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.black))),
          child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (paginaClicada) {
              _pageController.animateToPage(paginaClicada,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,


            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Início"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket), label: "Lojas"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant), label: "Restaurantes & Bars"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Serviços")
            ],
          ),
        ),
        body: SafeArea(
          child:

              ///Colocamos a PageView dentro do BlocProvider do Tipo "UserBloc"
              ///porque queremos que todos Wdgets dentro dele tenham acesso ao
              ///"UserBloc"
              PageView(
            controller: _pageController,
            onPageChanged: (p) {
              setState(() {
                _page = p;
              });
            },
            children: [
              HomeScreen2(),
              Store_Home_Screen("Loja de venda a Retalho"),
              Store_Home_Screen("restaurante"),
              Restaurantes_Home_Screen()
            ],
          ),
        ),
        //floatingActionButton: _buildFloating(),
      ),
    );
  }
}
