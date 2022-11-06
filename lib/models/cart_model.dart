import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mo_brada_2022/data/cart_product.dart';
import 'package:mo_brada_2022/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
List<CartProduct> products =[];


String? couponCode;
int discountPercentage = 0;

bool isLoading = false;

CartModel(this.user){
  if(user.isLoggedIn())
  _loadCartItems();
}

static CartModel of (BuildContext context) =>
    ScopedModel.of<CartModel>(context);

void addCartItem(cartProduct){

  //0 - Adicionar o Producto selecionado na lista de productos
  //1 - Criando uma colletion "cart" dentro da colletion
  //do "user" activo;

  //2 - Adicionando o carrinho criado como document da
  // colletion "cart" criada;

  //3 - colocar o id do firebase do  "carrinho" criado
  // como uma propriedade da proprieddade cart_id do
  // proprio carrinho.

  products.add(cartProduct);

  FirebaseFirestore.instance.collection("users").
  doc(user.firebaseUser?.uid).collection("cart").
  add(cartProduct.toMap()).then((doc){
    cartProduct.cart_id = doc.id;
  });
  notifyListeners();
}
//
  void removeCartItem(CartProduct){
    FirebaseFirestore.instance.collection("users").
    doc(user.firebaseUser?.uid).collection("cart").
    doc(CartProduct.cart_product_id).delete();

    products.remove(CartProduct);
    notifyListeners();

  }

  //DIMINUI A QUANTIDADE DO PRODUCTO EM QUESTÃO
  void dimProduct(CartProduct cartProduct){
    int? c = cartProduct.quantity;

    if (c != null) c--;
  cartProduct.quantity = c;

  FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart")
  .doc(cartProduct.cart_id).update(cartProduct.toMap());

  notifyListeners();
  }

  //AUMENTA A QUANTIDADE DO PRODUCTO EM QUESTÃO
  void aumProduct(CartProduct cartProduct){

    int? c = cartProduct.quantity;

    if (c != null) c++;
    cartProduct.quantity = c;

    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid).collection("cart")
        .doc(cartProduct.cart_id).update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupom(String coupomCode, int discountPercentage){
  this.couponCode = couponCode;
  this.discountPercentage = discountPercentage;
  }

  //SERÁ CHAMDO PARA ACTULIZAR OS VALORES SEMPRE QUE A TELA ABRE
  void updatPrices(){
  notifyListeners();
  }

  double getProductsPrice(){

  double price = 0.0;

  //1- Para cada item em "products" multiplica quantidade X Preço
  // e o resultado acrescenta no valor do "price"
  for(CartProduct c in products){
    if (c.productData != null)
      if (c.productData != null)
        price = c.productData!.price;

    if(price != null && c.quantity != null) {

      price  += (c.quantity! * c.productData!.price)!;
    }


  } return price;

  }

  double getDiscount(){
  return getProductsPrice() * discountPercentage /100;
  }

  double getShipPrice(){
  return 500.0;

  }

  //GUARDANDO O PEDIDO (ORDER)
  Future<String?> finishOrder() async {
  if(products.length == 0) return null;
  isLoading = true;
  double  productsPrice = getProductsPrice();
  double shiPrice = getShipPrice();
  double discount = getDiscount();


//GUARDANDO o ID do Ped
// ido na variavel reOrder
  DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
    {"clientId": user.firebaseUser?.uid,
      "products": products.map((cartProduct)=>
      cartProduct.toMap()).toList(),
      "shipPrice": shiPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shiPrice,
      "status": 1
    }
  );

  //GUARDANDO O ID DO PRODUTO NA COLLETION ORDERS DENTRO DO USUÁRIO
  FirebaseFirestore.instance.collection("users").doc(user.firebaseUser?.uid)
    .collection("orders").doc(refOrder.id).set({
  //Todo: Alterar o ID da Order , para um código mais comprensivel
    "orderId": refOrder.id
  });

  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("users")
    .doc(user.firebaseUser?.uid).collection("cart").get();

  //DELETE CADA DOCUMENTO NO QUERY OBTIDO
  for (DocumentSnapshot doc in query.docs){
    doc.reference.delete();

    //Limpando a lista local de productos selecionados
    products.clear();

  //LIMPANDO VARIAVEIS
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }


  }


  //Obtendo os dados do carrinho do User Logado no Firebase
  Future<void> _loadCartItems() async {
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance.collection("users")
        .doc(user.firebaseUser?.uid).collection("cart")
        .get();

    //Convertendo cada documento obtido em um CartProduct
    //Transformando todos esses CartProducts em uma Lista
    //Colocando essa Lista na nossa Lista "products" que é
    // do tipo CartProduct
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();


  }
}