import 'package:CovidRelief/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CovidRelief/models/user.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid : user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map(_userFromFirebaseUser);
  }


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
  Future signInEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user  = result.user;
      return user;

      


    } catch(error){
      print(error.toString());
      return null;

    }
  }


  //metodo para registrarse

  Future registerEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user  = result.user;
     // creamos un nuevo documento para el usuario con el uid
      await DatabaseService(uid: user.uid).updateUserData('birthday', 'country', 'creation', 'gender', "name", "phone", "state", "type");
      return _userFromFirebaseUser(user);


    } catch(error){
      print(error.toString());
      return null;

    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  //cerrar sesion
}