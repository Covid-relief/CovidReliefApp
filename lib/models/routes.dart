import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/screens/home/user_list.dart';

void main() {
    runApp(new MaterialApp(
      title: 'Named Routes Demo',
      home: UserList(), 
      // Inicie la aplicación con la ruta con nombre. En nuestro caso, la aplicación comenzará
      // en el Widget FirstScreen
      // initialRoute: '/',
      routes: <String, WidgetBuilder>{
        // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
        // '/': (context) => UserList(),
        // Cuando naveguemos hacia la ruta "/second", crearemos el Widget SecondScreen
        '/userProfile': (BuildContext context) => new UserProfile(),
      },
    ));
  }