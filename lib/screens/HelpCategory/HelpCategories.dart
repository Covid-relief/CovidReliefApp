import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/HelpCategory/PersonalizedHelp.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Category extends StatelessWidget {
  final AuthService _auth = AuthService();

  String typeOfHelp;
  Category({this.typeOfHelp});
  var categoryOfHelp;

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
 // State<StatefulWidget> createState() {
    Widget build(BuildContext context) {

      Future<void> _sendAnalyticsEvent(String categoryClicked) async {
        await analytics.logEvent(
          name: 'click_'+categoryClicked
        );
      }

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
              title: Text('Covid Relief', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 25),),
              //backgroundColor: Colors.lightBlue[900],
              ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.redAccent[400],
                  ),
                  child: Text(
                    'Covid Relief', 
                    style: TextStyle(
                      height: 5.0,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Open Sans',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Inicio',),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Cerrar Sesión'),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Authenticate()),);
                  },
                ),
              ],
            ),
          ),
            body:
            ListView(
              padding: const EdgeInsets.all(15),
              children: <Widget>[
                SizedBox(height: 40,),
                Container(
                  height: 90,
                  child: const Center(child: Text('Categorías de ayuda', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    //elevation: 5.0,
                    shape: StadiumBorder(),
                    onPressed:() async {
                      categoryOfHelp='business';
                      _sendAnalyticsEvent(categoryOfHelp);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp)),);
                    },
                    child: new Text("Business", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    //elevation: 5.0,
                    shape: StadiumBorder(),
                    onPressed:() {
                      categoryOfHelp='tecnología';
                      _sendAnalyticsEvent(categoryOfHelp);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp)),);
                    },
                    child: new Text("Tecnología", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    textColor: Colors.white,
                    //elevation: 5.0,
                    color: Colors.blueAccent,
                    shape: StadiumBorder(),
                    onPressed:() async {
                      categoryOfHelp='medicina';
                      _sendAnalyticsEvent(categoryOfHelp);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp)),);
                    },
                    child: new Text("Medicina", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(70,0,70,0),
                  child:
                  RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    //elevation: 5.0,
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    shape: StadiumBorder(),
                    onPressed:() async {
                      categoryOfHelp='psicología';
                      _sendAnalyticsEvent(categoryOfHelp);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Help(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp)),);
                    },
                    child: new Text("Psicología", style: TextStyle(fontSize: 20)),
                  ),
                ),
                Container(
                  height: 100,
                ),
              ],
            )
      );
    }
  }





