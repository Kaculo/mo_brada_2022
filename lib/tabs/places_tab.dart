import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return ListView(
            children: snapshot.data!.docs.map((doc)=> PlacesTile(doc)).toList(),
          );
        }
      }
    );
  }
}
