import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //FirebaseAuth _authF = FirebaseAuth.instance;

  // Facebook login logic
  Future<FirebaseUser> _loginWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logIn(['email']);

    debugPrint(result.status.toString());

    if (result.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken myToken = result.accessToken;
      AuthCredential credential =
          FacebookAuthProvider.getCredential(accessToken: myToken.token);
      FirebaseUser user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      return user;
    }
    return null;
  }

  bool rememberMe = false;
  final storage =
      new FlutterSecureStorage(); // function to store password in KeyStore

  final AuthService _auth = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';

  void _showPasswordEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("¿Olvidaste tu contraseña?"),
          content: new Text(
              "Se ha enviado exitosamente un correo electrónico para cambiar tu contraseña"),
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        if (rememberMe) {
          // function
        } else {
          // function
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 1.0,
        title: Text('Iniciar Sesión'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Registrarse'),
            color: Color(0xFF1976D2),
            onPressed: () => widget.toggleView(),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Color(0xFF1976D2),
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(30)),
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
                decoration: textInputDecoration.copyWith(
                    hintText: 'Correo electrónico'),
                validator: (val) =>
                    val.isEmpty ? 'Ingrese un correo electrónico válido' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Contraseña'),
                validator: (val) => val.length < 6
                    ? 'Ingrese una contrasena con más de 6 caracteres'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                  storage.write(key: "mykey", value: password);
                },
              ),
              new Container(
                  child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF1976D2)),
                          ),
                          onPressed: () async {
                            _auth.sendPasswordReset(email);
                            _showPasswordEmailSentDialog();
                          }))
                ],
              )),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    String value = await storage.read(key: "mykey");
                    if(_formKey.currentState.validate()){
                      dynamic result = await _auth.signInEmailandPassword(email, value);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      if(result == null) {
                        setState(() {
                          error = 'No es posible Iniciar Sesión con ese correo/constraseña';
                        });
                      }
                    }
                  }
              ),
              // Google Sign In button

              GoogleSignInButton(
                onPressed: () async {
                  /*if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      setState(() {
                        error = 'No es posible Iniciar Sesión';
                      });
                    }
                  }*/

                  _auth.signInWithGoogle();
                },
              ),
              // Facebook login button
              FacebookSignInButton(
                // calls function
                onPressed: _loginWithFacebook,
              ),
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