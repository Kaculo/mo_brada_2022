import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{

  late String category;
  late String id;

  late String title;
  late String description;
  late double price;

  late List images;
  late List product_options;

  ProductData.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot){
    id = snapshot.id;
    title = snapshot.data()!['title'];
    description = snapshot.data()!['description'];
    price = snapshot.data()!["price"]+ 0.0;
    images = snapshot.data()!["images"];
    product_options= snapshot.data()!["sizes"];
  }


    Map<String, dynamic> toResumedMap(){
      return{
        "title": title,
        "description": description,
        "price": price,
      };
    }
  }
