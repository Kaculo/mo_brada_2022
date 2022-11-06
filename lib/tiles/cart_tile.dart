import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/cart_bloc.dart';
import 'package:mo_brada_2022/data/cart_product.dart';
import 'package:mo_brada_2022/data/product_data.dart';

//Alguns dados como, Foto, Titulo do Producto, etc...
// dados apresentados no CartTile, não estão armazenados
//no CartProduct, eles são carregados directamente o firebase
// utilizando a Id do CartProduct p/ identificar os dados a apresentarr
class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  final _cartBloc = BlocProvider.getBloc<CartBloc>();

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      _cartBloc.updatPrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "${cartProduct.productData.price.toStringAsFixed(2)} Kz",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  BlocProvider(
                    dependencies: [],
                    blocs: [Bloc((context) => CartBloc())],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                          onPressed: cartProduct.quantity > 1
                              ? () {
                                  _cartBloc.dimProduct(cartProduct);
                                }
                              : null,
                        ),
                        Text(cartProduct.quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _cartBloc.aumProduct(cartProduct);
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.red[700]
                          ),
                          child: Text("Remover", style: TextStyle(color: Colors.grey[500]),),
                          onPressed: () {
                            _cartBloc.removeCartItem(cartProduct);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child:
            //CASO NÃO TEMOS OS DADOS DO PRODUCTO,
            cartProduct.productData == null
                ?
                //Vamos a busca do nosso producto dentro da sua categoria ESPECIFICA
                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("products")
                        .doc(cartProduct.category)
                        .collection("items")
                        .doc(cartProduct.cart_product_id)
                        .get(),

                    //Aqui o snapshot é o documento que acabamos de
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //Convertendo os dados extraidos do firebase em um "ProductData"
                        // e armazenando a iformação em um "cartProduct"..
                        //***Estamos a armazenar esta informação, para não termos que ir a busca
                        //sempre o user abre o carrinho, apenas se reiniciar o App.
                        cartProduct.productData =
                            ProductData.fromDocument((snapshot.data));
                        return _buildContent();
                      } else {
                        return Container(
                          height: 70.0,
                          child: CircularProgressIndicator(),
                          alignment: Alignment.center,
                        );
                      }
                    },
                  )
                : _buildContent());
  }
}
