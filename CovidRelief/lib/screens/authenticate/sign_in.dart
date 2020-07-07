import 'package:CovidRelief/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(backgroundColor: Colors.red,
      elevation: 0.0,
      title: Text("Sign in"),
      ),
      body:Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 50.0),
      child: RaisedButton(
        child: Text("sign in anon"),
      onPressed: () async{
        dynamic result = await _auth.signInAnon();
        if (result== null){
          print("error sign in");
        }else{
          print("signed in");
          print(result);
        }


      })
      ,) ,

    );
  }
}