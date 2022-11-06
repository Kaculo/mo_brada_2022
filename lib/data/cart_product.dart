import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mo_brada_2022/data/product_data.dart';


class CartProduct {
  //NÃO VAOMOS ARMAZENAR OS DADOS DO PRODUCTO NO CARRINHO
  //E SIM O ID DO PRODUCTO

//Declaração de propriedades do productos no carrinho que não vão ser
//alteradas se alterarmos as configurações gerais do mesmo producto
  String? cart_id;
  String? category;
  String? cart_product_id;

  int? quantity;
  String? size;

  ProductData? productData;
  CartProduct();

  //CONTRUSTOR
  //Transferindo dados do producto para o Carrinho
  CartProduct.fromDocument(DocumentSnapshot <Map<String, dynamic>> cartSnapshot) {
    cart_id = cartSnapshot.id;
    category = cartSnapshot.data()!["category"];
    cart_product_id = cartSnapshot.data()!["cart_product_id"];
    quantity = cartSnapshot.data()!["quantity"];
    size = cartSnapshot.data()!["size"];
  }

  //CONVERTENDO O PRODUCTO DO CARRINHO EM UM MAPA
  // PARA ARMAZENAR NA BASE DE DADOS
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "cart_product_id": cart_product_id,
      "quantity": quantity,
      "size": size,
      //"toResumedMap" cria um resumo do producto selecionado
      "product": productData?.toResumedMap()
    };
  }
}
