import 'package:CovidRelief/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/services/database.dart';

class UserProfile extends StatelessWidget {

@override
  Widget build(BuildContext context) {
 
    // this variable allows us to get the uid that contains the info of the user
    final user = Provider.of<User>(context);

    return new StreamBuilder(
      // here we get the info from the document of the collection of the user
      stream: Firestore.instance.collection('perfiles').document(user.uid).snapshots(),
      builder: (context, snapshot) {

        // if there is no data in the collection display "No data". This should never occur
        if (!snapshot.hasData) {
          print('No data');
        }
        // we use this variable to display info from the user
        var userData = snapshot.data;

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
                    title: Text(userData['name']),
                    subtitle: Text(userData['country'])
                    ),
                  // Display more info about
                  Text(userData['gender'])
                ],
              )
            ),
          ),
        );
      } // builder
    );
  }
}