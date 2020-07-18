import 'package:CovidRelief/models/profile.dart';
import 'package:flutter/material.dart';


class UserTile extends StatelessWidget {

  final Perfiles user;
  UserTile({this.user});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:12.0),
      child : Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          /*leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blue[900],
            
          ),*/
          title: Text(user.name),
          subtitle: Text(user.type),
          trailing: Text(user.birthday),
          


          
          
          
          
        ),
        
      )
      );
  }
}