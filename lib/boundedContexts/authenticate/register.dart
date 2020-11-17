import 'package:CovidRelief/boundedContexts/home/settings_form.dart';
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

  //terminos y condiciones Alert PopUp
  createAlertDialog(BuildContext context){

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Acepte los términos y condiciones para continuar"),
        content: Text("Los análisis y consejos expuestos en esta plataforma, son"
            " exclusivamente responsabilidad de su autor. Los consejos, trabajos"
            " o aseveraciones aquí compartidas, no son necesariamente compartidas"
            " ni representan la postura oficial de la Universidad Francisco Marroquín"),

        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Acepto los términos y condiciones'),
            color: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              //side: BorderSide(color: Colors.red)
            ),
            onPressed: () async {
              String value = await storage.read(key: "mykey");
              if (_formKey.currentState.validate()) {
                print('Se ha registrado exitosamente');
                final result = await _auth.registerEmailandPassword(email, value);
                if (result == null) {
                  setState(() {
                    error = 'Por favor ingrese un correo valido';
                  });
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserDataForm()),);
                }
              }
            },
          )
        ],
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                const Color(0xFFFF5252),
                const Color(0xFFFF1744)
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp
            ),
          ),
        ),
        //backgroundColor: Colors.cyan[700],
        //elevation: 0.0,
        title: Text('Registrarse',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFamily: 'Montserrat',
              fontSize: 25),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Iniciar Sesión',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    ),
              ),
              color: Colors.redAccent,
              onPressed: () => widget.toggleView(),
              shape: RoundedRectangleBorder(side: BorderSide(
                  color: Colors.red,
                  width: 0.5,
                  style: BorderStyle.solid
              ), borderRadius: BorderRadius.circular(40)),
            ),
          )
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
              SizedBox(height: 35.0),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () async {
                    // popup de terminos y condiciones
                    createAlertDialog(context);
                },
              ),
              SizedBox(height: 5.0),
              GoogleSignInButton(
                onPressed: null /*() async {
                  _auth.signInWithGoogle();
                },*/
              ),
              FacebookSignInButton(
                onPressed: null,
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