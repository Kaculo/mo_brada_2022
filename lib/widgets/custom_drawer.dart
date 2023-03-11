import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/screens/login_screen.dart';
import 'package:mo_brada_2022/screens/singup_screen.dart';
import 'package:mo_brada_2022/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;
  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buidDrawerBack() => Container(
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
                      251,
                      192,
                      45,
                      1
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
        );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buidDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                  height: 170.0,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: Text(
                          "MoBrada",
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold,
                          color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: StreamBuilder(
                          stream: _loginBLoc.outState,
                          builder: (context, snapshot) {
                             return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Olá, ${!_loginBLoc.isLoggedIn() ? "não tem secção iniciada" : _loginBLoc.
                                      userData["first_name"]}",
                                      style: const TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Container(
                                      width: 120,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Theme.of(context).hintColor,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>SingUpScreen()));
                                      },
                                    ),
                                  ],

                                ),
                                GestureDetector(
                                  child:  Row(
                                    children:
                                    !_loginBLoc.isLoggedIn() ? [
                                      Icon(Icons.arrow_forward,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Text(
                                        "Entre ou cadastre-se >",
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                    ] : [
                                      Icon(Icons.arrow_back,
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Text(
                                        "Sair",
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                    if (!_loginBLoc.isLoggedIn())
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>LoginScreen())
                                      );
                                    else
                                      _loginBLoc.singOut();
                                  },
                                )
                              ],
                            );
                          }
                        ),
                      )
                    ],
                  )),
              const Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Productos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
