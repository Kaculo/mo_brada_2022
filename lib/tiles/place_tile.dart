import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlacesTile extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> snapshot;

  PlacesTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              snapshot.data()["imsge"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data()["title"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(snapshot.data()["address"],
                textAlign: TextAlign.start,)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[TextButton(
              child: Text("Ver no Mapa", style: TextStyle(color: Colors.blue),),

              onPressed: (){
                launch("https://www.google.com/maps/search/?api=1&query=${snapshot.data()["lat"]},"
                    "${snapshot.data()["long"]}");
              },
            ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.red[700]
                ),
                child: Text("Ligar", style: TextStyle(color: Colors.blue,),),
                onPressed:  (){
                  //"launch" aqui estamos a utilizar para abrir
                  launchUrlString("tel:${snapshot.data()["phone"]}");
                },)
                ],
          )
        ],
      ),
    );
  }
}
