import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:provider/provider.dart';

class HelpRequests extends StatefulWidget {
  String categoryOfHelp;
  HelpRequests({this.categoryOfHelp});
  
  @override
  _HelpRequestsState createState() {
    return _HelpRequestsState(categoryOfHelp:categoryOfHelp);
  }
}

class _HelpRequestsState extends State<HelpRequests>{
  final AuthService _auth = AuthService();

  String categoryOfHelp;
  _HelpRequestsState({this.categoryOfHelp});

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
          title: Text(
            'Covid Relief',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 25),
          ),
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
                title: Text(
                  'Inicio',
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  'Perfil',
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfile()),
                  );
                },
              ),

              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Cerrar Sesión'),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                },
              ),
            ],
          ),
        ),
        // agregar momento de carga
        body: StreamBuilder(
          stream: Firestore.instance.collection('solicitarayuda').where("state", isEqualTo: "unattended").where("category", isEqualTo: categoryOfHelp).snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myPost = snapshot.data.documents[index];
                return pendingRequests(
                  myPost['category'], 
                  myPost['code'],
                  myPost['contactMail'], 
                  myPost['contactMessage'],
                  myPost['description'], 
                  myPost['email'],
                  myPost['name'], 
                  myPost['phone']
                );
              }
            );
          },
        )
    );
  }

  Widget pendingRequests(String category, int code, bool contactMail, bool contactMessage, String description, String email, String name, String phone){
    // Basicamente se usaran esas variables para que al presionar el boton de capturar se mande
    // un mensaje o correo a cada involucrado
    // marcar caso como atendido
    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Flexible(
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                    style: TextStyle(height: 2.0),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  onPressed: null,
                  child: Text("Conectar"),
                  // cambiar esto a enabled
                  disabledTextColor: Colors.white,
                  disabledColor: Colors.blueAccent,
                  shape: StadiumBorder(),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}