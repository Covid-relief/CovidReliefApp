import 'package:CovidRelief/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_tile.dart';


class UserProfile extends StatelessWidget {

  final Perfiles user;
  UserProfile({this.user});

// Lacks conection to user
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:12.0, bottom: 12.0),
        child: Card(
          child: Column(
            children: <Widget>[
              // Circle for profile picture
              ListTile(
                leading: CircleAvatar(
                radius: 500.0,
                backgroundColor: Colors.blue[900]),
              ),
              // Diplay name and country
              ListTile(
                title: Text('Nombre completo'), //Text(user.name),
                subtitle: Text('País') //Text(user.country))
                ),
              // Display more info about
              Text('More info')
            ],
          )
        )
      );
  }
}