import 'package:CovidRelief/models/forms.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CovidRelief/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseDatabase _authHelpForm = FirebaseDatabase.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // UserForm _helpRequestForm(FirebaseUser userform) {
  //   return userform != null ? UserForm(uid: userform.uid) : null;
  // }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //metodo para login con email y password
  Future signInEmailandPassword(String email, String password) async {
    String retVal = "error";
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      retVal = "success";
      return user;
    } catch (error) {
      print(error.toString());
      retVal = error.message;
      return null;
    }
  }

  //metodo para registrarse
  // Future requestHelpForm() async {
  //   try{
  //     DatabaseReference result = await _authHelpForm.reference();
  //
  //     await DatabaseService().updateHelpForm(
  //         'birthday',
  //         'country',
  //         'creation',
  //         'gender');
  //     return _helpRequestForm();
  //   } catch (error) {
  //     print(error.toString());
  //     return null;
  //   }
  //   }

  //metodo para registrarse
  Future registerEmailandPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // creamos un nuevo documento para el usuario con el uid
      await DatabaseService(uid: user.uid).updateUserData(
          'birthday',
          'country',
          'creation',
          'gender',
          "name",
          "phone",
          "state",
          "type");
      return _userFromFirebaseUser(user);
    } catch (error) {
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

  Future<void> sendPasswordReset(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }
  //cerrar sesion

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }
}
