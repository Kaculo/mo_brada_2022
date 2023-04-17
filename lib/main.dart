import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mo_brada_2022/blocs/location_bloc.dart';
import 'package:mo_brada_2022/screens/home_screen.dart';
import 'blocs/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
   //    Initialize FlutterFire
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("O erro do snap é: ${snapshot.error}");
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider(
            blocs: [
              Bloc((_) => LoginBLoc()),
              Bloc((_) => LocationBloc()),
            ],
            dependencies: [],
            child: MaterialApp(
                title: "MoBrada",
                theme: ThemeData(
                    primarySwatch: Colors.red,
                    primaryColor: Colors.red
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen()
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
        /*
        return

        /**GERIR ABAIXO ERROS NA INICIALIZAÇÃO COM FIREBASE**/


        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ScopedModel<UserModel>(
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model){
                  return ScopedModel<CartModel>(
                    model: CartModel(model),
                    child: MaterialApp(
                        title: "Flutter's Clothing",
                        theme: ThemeData(
                            primarySwatch: Colors.blue,
                            primaryColor: Color.fromARGB(255, 4, 125, 141)
                        ),
                        debugShowCheckedModeBanner: false,
                        home: HomeScreen()
                    ),
                  );
                }
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();*/
      },
    );
  }
}