import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final storage = new FlutterSecureStorage();
  final AuthService _auth = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  Firestore _firestore = Firestore.instance;

  String error = '';

  // text field state
  String email = '';
  String password = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[700],
        elevation: 0.0,
        title: Text('Registrarse',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'Open Sans',
              fontSize: 25),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Iniciar Sesión',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Open Sans',
                  ),
            ),
            color: Colors.teal[200],
            onPressed: () => widget.toggleView(),
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Colors.teal[200],
                width: 0.5,
                style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(40)),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Correo electrónico'),
                validator: (val) => val.isEmpty ? 'Ingrese un correo electrónico válido' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Contraseña'),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Ingrese una contrasena de más de 6 caracteress' : null,
                onChanged: (val) {
                  setState(() => password = val);
                  storage.write(key: "mykey", value: password);
                },
              ),
              SizedBox(height: 15.0),
              RaisedButton(
                color: Colors.teal,
                child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String value = await storage.read(key: "mykey");
                  if(_formKey.currentState.validate()){
                    print('Se ha registrado exitosamente');
                    final result = await _auth.registerEmailandPassword(email, value);
                    if(result == null) {
                      setState(() {
                        error = 'Por favor ingrese un correo valido';
                      });
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserDataForm()),);
                    };
                  }
                },
              ),
              GoogleSignInButton(
                onPressed: () async {
                  _auth.signInWithGoogle();
                },
              ),
              FacebookSignInButton(
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}