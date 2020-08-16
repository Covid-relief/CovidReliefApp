import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text('Registrarse'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Iniciar Sesión'),
            color: Color(0xFF1976D2),
            onPressed: () => widget.toggleView(),
            shape: RoundedRectangleBorder(side: BorderSide(
                color: Color(0xFF1976D2),
                width: 1,
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
              
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String value = await storage.read(key: "mykey");
                  if(_formKey.currentState.validate()){
                    print('Se ha registrado exitosamente');
                    dynamic result = await _auth.registerEmailandPassword(email, value);
                    if(result == null) {
                      setState(() {
                        error = 'Por favor ingrese un correo valido';
                      });
                    }
                  }
                },
              ),
              RaisedButton(
                color: Colors.blue[400],
                child: Text(
                  'Sign With Google',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  _auth.signInWithGoogle();

                },
              ),
              SizedBox(height: 12.0),
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