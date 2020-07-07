import 'package:firebase_auth/firebase_auth.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;


  //sign anon
  Future signInAnon() async {
    try{
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;

    } catch(e){
      print(e.toString());
      return null;

    }
  }


  //metodo para login con email y password
  //metodo para registrarse
  //cerrar sesion
}