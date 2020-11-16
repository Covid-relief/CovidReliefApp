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
  final storage = new FlutterSecureStorage(); // function to store password in KeyStore

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
        //elevation: 1.0,
        title: Text('Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontFamily: 'Montserrat',
            fontSize: 25),),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Registrarse',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Open Sans',
                ),
              ),
              color: Colors.redAccent,
              onPressed: () => widget.toggleView(),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.red,
                      width: 0.5,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30)),
            ),
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
                                fontSize: 15, color: Colors.redAccent),
                          ),
                          onPressed: () async {
                            _auth.sendPasswordReset(email);
                            _showPasswordEmailSentDialog();
                          }))
                ],
              )),
              RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () async {
                    String value = await storage.read(key: "mykey");
                    if(_formKey.currentState.validate()){
                      dynamic result = await _auth.signInEmailandPassword(email, value);
                      if(result == null) {
                        setState(() {
                          error = 'No es posible Iniciar Sesión con ese correo/constraseña';
                        });
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      };
                    }
                  }
              ),
              SizedBox(height: 5.0),
              // Google Sign In button
              GoogleSignInButton(
                onPressed: null /*() async {
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.signInWithGoogle();
                    if (result == null) {
                      setState(() {
                        error = 'No es posible Iniciar Sesión';
                      });
                    }
                  }
                  _auth.signInWithGoogle();
                },*/
              ),
              // Facebook login button
              FacebookSignInButton(
                // calls function
                onPressed: null //_loginWithFacebook,
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