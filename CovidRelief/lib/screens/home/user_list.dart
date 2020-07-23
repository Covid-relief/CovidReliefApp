import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_tile.dart';


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<Perfiles>>(context) ?? [];

    
     return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserTile(user: users[index]);
      },
    );
  }
}