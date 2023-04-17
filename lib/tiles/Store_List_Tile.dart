import 'package:auto_size_text/auto_size_text.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mo_brada_2022/data/store_data.dart';
import 'package:mo_brada_2022/screens/product_catergory_screen.dart';
import 'dart:math';
import '../blocs/location_bloc.dart';
import 'category_tile.dart';



  class Store_List_Tile extends StatelessWidget {
  final String type;
  final StoreData store;

  var _locationBloc = BlocProvider.getBloc<LocationBloc>();


  /*Future<QuerySnapshot> firestore = Firestore.instance.collection('lojas')
      .doc('ola_food')
      .collection('Categoria_de_produtos').get();*/

  Store_List_Tile(this.type, this.store);


  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction





  @override
  Widget build(BuildContext context) {
    //Inkwell - é igual ao gesture detector, mas com uma animação
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => Product_Category_Screen(store))));
      },
      child: Card(
        child: type == "grid"
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                store.store_images[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(

             child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(store.title, style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Divider(
                        height: 5,
                        thickness: 1,
                      ),
                    ),
                    Text(store.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13.0),),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Divider(
                        height: 5,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(store.address,
                        style: const TextStyle(
                            fontSize: 12.0),
                        maxLines: 2,),
                    ),
                    Expanded(
                      child: AutoSizeText(store.type, textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 10.0,
                          fontWeight: FontWeight.bold
                        ),
                        maxLines: 2,),
                    ),
                    StreamBuilder(
                      stream: _locationBloc.outDistance,
                      builder: (context, snapshot) {
                        return
                          AspectRatio(
                            aspectRatio: 1,
                            child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                          target:LatLng(45.521563, -122.677433),
                        //LatLng(_locationBloc.lat, _locationBloc.long),
                        zoom: 14.0,
                        ),
                        markers: _locationBloc.markers,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        onMapCreated: _locationBloc.onMapCreated,
                        ));

                      }
                    )
                  ],
                ),
              ),
            )
          ],

        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 1,
                child: Image.network(
                  store.store_images[0],
                  fit: BoxFit.cover,
                  height: 100,
                  width: 200,
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(store.title, style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Divider(
                        height: 5,
                        thickness: 1,
                      ),
                    ),
                    Text(store.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12.0),),
                    /*Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child:
                    ),*/
                    AutoSizeText(store.address,
                      style: const TextStyle(
                          fontSize: 12.0),
                      maxLines: 2,)
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }



}
