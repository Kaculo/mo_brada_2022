import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/cart_bloc.dart';
import 'package:scoped_model/scoped_model.dart';

class PriceCard extends StatelessWidget {
  final VoidCallback buy;
  final _cartBloc = BlocProvider.getBloc<CartBloc>();

  PriceCard(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: BlocProvider(
          blocs: [Bloc((context) => CartBloc())],
          dependencies: [],
          child: StreamBuilder(
            stream: _cartBloc.outData,
            builder: (context, snapshot){
              //PEGANDO OS PREÇOS
              double price = _cartBloc.getProductsPrice();
              double discount = _cartBloc.getDiscount();
              double ShipPrice = _cartBloc.getShipPrice();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Resumo do Pedido",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Subtotal"),
                      Text("${price.toStringAsFixed(2)} Kz"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Desconto"),
                      Text("${discount.toStringAsFixed(2)} Kz"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Frete"),
                      Text("${ShipPrice.toStringAsFixed(2)} Kz"),
                    ],
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${(price-discount+ShipPrice).toStringAsFixed(2)} Kz",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: Text("Finalizar Pedido", style: TextStyle(color: Colors.white),),
                   onPressed: buy,
                  )
                ],
              );
            },
          )
        ),
      ),
    );
  }
}
