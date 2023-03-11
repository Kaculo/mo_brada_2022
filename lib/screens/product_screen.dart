import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/cart_bloc.dart';
import 'package:mo_brada_2022/blocs/login_bloc.dart';
import 'package:mo_brada_2022/data/cart_product.dart';
import 'package:mo_brada_2022/data/product_data.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

//ESTE SCREEN MOSTRA O PRODUCTO SELECIONADO NA CATEGORY SCREEN
class ProductScreen extends StatefulWidget {
  final ProductData product;

//Recebendo o Producto para usar nesta página.
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final _loginBLoc = BlocProvider.getBloc<LoginBLoc>();
  final _cartBloc = BlocProvider.getBloc<CartBloc>();
  final ProductData product;

  //Vriavel para armazenar o tamanho selecionado pelo usuário!
  String? size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme
        .of(context)
        .primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            //Todo: Explorar o Plugn Carousel
            child:
            CarouselSlider(
              options: CarouselOptions(),
              items: product.images.map((url) {
                return Container(
                    child: Center(
                    child: Image.network(url, fit: BoxFit.cover, width: 1000)
                ));
              }).toList(),
            )
            /* Carousel(
              //Transformando os Links das Imagens em Imagens
              //Depois tranformamos essas Imagens em uma Lista (array)
              // porque o "carousel" precisa de imagens e não links.
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              //Tamanho dos pontinhos que ficam por baixo da imagem
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              //autoplay-faz os items no carousel mudarem automaticamente
              autoplay: false,
            ),*/
          ),
          Padding(
            padding: EdgeInsets.all(16.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "${product.price.toStringAsFixed(2)} Kz",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                      ),
                      children:
                      product.product_options.map((tamanho_Selecionado) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              size = tamanho_Selecionado;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(
                                    color: tamanho_Selecionado == size
                                        ? primaryColor
                                        : Colors.grey,
                                    /**Aqui havia um grey[500] para demonstrar desactivação**/
                                    width: 3.0)),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(tamanho_Selecionado),
                          ),
                        );
                      }).toList()),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: BlocProvider(
                    dependencies: [],
                    blocs: [Bloc((context) => CartBloc())],
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBABF21),
                          disabledBackgroundColor: primaryColor),
                      onPressed: size != null
                          ? () {
                        //Se o User estiver Logado
                        if (_loginBLoc.isLoggedIn()) {
                          //ADICIONANDO PRODUTO AO CARRINHO
                          //criando um novo cartProduct
                          //Todo: Verificar se aquele producto com as mesmas especificações já não está adicionado,
                          // se já, apenas aumentar a quantidade do mesmo.
                          CartProduct cartProduct = CartProduct();
                          cartProduct.size = size;
                          cartProduct.quantity = 1;
                          cartProduct.cart_product_id = product.id;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          _cartBloc.addCartItem(cartProduct);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CartScreen()));
                        } else {
                          //Se não estiver logado, abra a página de Login
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        }
                      }
                          : null,
                      child: Text(
                        _loginBLoc.isLoggedIn()
                            ? "Adicionar ao Carrinho"
                            : "Entre para Comprar",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
