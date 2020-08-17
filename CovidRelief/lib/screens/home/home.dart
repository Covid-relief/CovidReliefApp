import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_list.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child:  SettingsForm(),
        );
      });
    }
    return StreamProvider<List<Perfiles>>.value(
        value: DatabaseService().perfiles,
          //child: Container(
          child: Scaffold(
            backgroundColor: Colors.red[50],
            appBar: AppBar(
              title: Text('CovidRelief'),
              backgroundColor: Colors.red[400],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Cerrar Sesión'),
                  onPressed: () async {
                    await _auth.signOut();
                },
              ),
              FlatButton.icon(
                icon : Icon(Icons.settings),
                label: Text("Configuración"),
                onPressed:() => _showSettingsPanel(),
            )
            ],
          ),
          // personal data from settings_form.dart
          body: UserProfile(), //HAY QUE DESARROLLAR EL HOME
            // redirect to user profile
            //UserProfile(), //UserList(), 
        ),
      
    );
  }
}