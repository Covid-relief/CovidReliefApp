import 'package:CovidRelief/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_tile.dart';
import 'package:CovidRelief/services/database.dart';


class UserProfile extends StatelessWidget {

@override
  Widget build(BuildContext context) {
 
    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        // we use this variable to display info from the user
        UserData userData = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Perfil'),
            backgroundColor: Colors.red[400],
          ),
          body: Center(
            child: Card(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  // Circle for profile picture
                  ListTile(
                    leading: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.red[900]),
                  ),
                  // Diplay name and country
                  ListTile(
                    title: Text(user.uid), //Text(user.name),
                    subtitle: Text('País') //Text(userData.country))
                    ),
                  // Display more info about
                  Text('More info')
                ],
              )
            ),
          ),
        );
      } // builder
    );
  }
}