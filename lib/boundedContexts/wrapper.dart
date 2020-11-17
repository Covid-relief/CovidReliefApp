import 'package:CovidRelief/boundedContexts/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/boundedContexts/home/home.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/boundedContexts/home/settings_form.dart';



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
    
  }
}