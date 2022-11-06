import 'package:cloud_firestore/cloud_firestore.dart';

class StoreData{

  late String store_category;
  late String id;

  late String title;
  late String description;
  late int phone_number;
  late String email;
  late String address;
  late String type;

  late List store_images;
  late List product_options;

  StoreData.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot){
    id = snapshot.id;
    store_category = snapshot.data()!['store_category'];
    title = snapshot.data()!['title'];
    address = snapshot.data()!["address"];
    description = snapshot.data()!['description'];
    phone_number = snapshot.data()!["phone_number"];
    store_images = snapshot.data()!["images"];
    email = snapshot.data()!["email"];
    type = snapshot.data()!["type"];
  }

/**TODO: PODE SERVIR PARA APRESENTAR OS DADOS DA LOJA**/
  Map<String, dynamic> toResumedMap(){
    return{
      "title": title,
      "description": description,
      "store_images": store_images,
    };
  }
}
