import 'package:CovidRelief/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/shared/constants.dart';


class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
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
        title: Text('Iniciar Sesión en Covid Relief'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Registrarse'),
            onPressed: () => widget.toggleView(),
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
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'Contraseña'),
                validator: (val) => val.length < 6 ? 'Ingrese una contrasena con más de 6 caracteres' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    dynamic result = await _auth.signInEmailandPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error = 'No es posible Iniciar Sesión con ese correo/constraseña';
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text("¿Olvidaste tu contraseña?",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await _auth.sendPasswordResetEmail(email: email).then((onVal) {
                    Navigator.pop(context, true);
                  }).catchError((onError) {
                    if (onError.toString().contains("ERROR_USER_NOT_FOUND")) {

                    } else if (onError
                        .toString()
                        .contains("An internal error has occurred")) {
                    }
                    };
                  );
                }),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
