import 'package:flutter/material.dart';

import 'package:mo_brada_2022/tabs/home_tab.dart';
import 'package:mo_brada_2022/tabs/orders_tab.dart';
import 'package:mo_brada_2022/tabs/places_tab.dart';
import 'package:mo_brada_2022/tabs/products_tab.dart';
import 'package:mo_brada_2022/widgets/cart_button.dart';
import 'package:mo_brada_2022/widgets/custom_drawer.dart';

class HomeScreen2 extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body:HomeTab(),
          drawer: CustomDrawer(
          _pageController
          ),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
                appBar: AppBar(
                  title: Text("Meus Pedidos"),
                  centerTitle: true,
                ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        ),

      ],
    );
  }
}
