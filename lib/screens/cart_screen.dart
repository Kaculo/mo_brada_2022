import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/cart_bloc.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/tiles/cart_tile.dart';
import 'package:mo_brada_2022/widgets/cart_price.dart';
import 'package:mo_brada_2022/widgets/discount_card.dart';
import 'package:mo_brada_2022/widgets/ship_card.dart';


import 'login_screen.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();
  final _cartBloc = BlocProvider.getBloc<CartBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: BlocProvider(
              dependencies: [],
              blocs: [Bloc((context) => CartBloc())] ,
              child: StreamBuilder(
                stream: _cartBloc.outData,
                builder: (context, snapshot) {
                  int nrItemsInCart = _cartBloc.products.length;
                  if(snapshot.hasData) {
                    return
                    Text(
                    //Se "nr_items_in_cart" for null ele retorna 0
                    "${nrItemsInCart} ${nrItemsInCart == 1
                        ? "ITEM"
                        : "ITENS"}",
                    style: TextStyle(fontSize: 17.0),);
                  } else {
                    return Container();
                  }
                },
              )
            ),
          )
        ],
      ),
      body: BlocProvider(
          dependencies: [],
        blocs: [Bloc((context) => CartBloc())],
        child: StreamBuilder(
          stream: _cartBloc.outData,
          builder: (context, snapshot){
            //SE O CARRINHO ESTIVER CARREGANDO E O USUÁRIO ESTÁ LOGADO
            if (_cartBloc.isLoading && _loginBLoc.isLoggedIn()) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // SE O USUÁRIO NÃO ESTÁ LOGADO
            else if (!_loginBLoc.isLoggedIn()) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.remove_shopping_cart, size: 80.0,
                      color: Theme
                          .of(context)
                          .primaryColor,),
                    SizedBox(height: 16.0,),
                    Text("Faça o Login para adicionar produtos!",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    SizedBox(height: 16.0,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          disabledBackgroundColor: Color(0xFFBABF21).withAlpha(140)),
                      child: Text('Entrar', style: TextStyle(fontSize: 18.0, color:Colors.white, )),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      },
                    )
                  ],
                ),
              );
            }
            //SE O USUÁRIO ESTIVER LOGADO, MAS NÃO TEM NENHUM PRODUCTO NO CARRINHO
            else if (_cartBloc.products == null || _cartBloc.products.length == 0) {
              return Center(
                  child: Text("Nenhum produto no carrinho!",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,));
            }

            //SE O USUÁRIO ESTIVER LOGADO E TIVER PRODUCTOS NO CARRINHO
            else {
              return ListView(
                children: <Widget>[
                  Column(
                    //CONVERTENDO CADA PRODUTO EM UMA CartTile
                    children: _cartBloc.products.map(
                            (product) {
                          return CartTile(product);
                        }).toList(),
                  ),
                  //Todo: apenas os produtos vão rolar, o resto é fixo;
                  DiscountCard(),
                  ShipCard(),
                  PriceCard(() async {
                    String? orderId = await _cartBloc.finishOrder();
                    if (orderId != null)
                      //SE O PEDIDO FOI EFECTUADO COM SUCESSO,
                      //ABRA O RESUMO DO PEDIDO
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => OrderScreen(orderId))
                      );
                  }),
                ],
              );
            }
          },
        )
      )
    );
  }
}
