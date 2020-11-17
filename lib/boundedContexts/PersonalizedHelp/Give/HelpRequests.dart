import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/boundedContexts/authenticate/authenticate.dart';
import 'package:CovidRelief/boundedContexts/home/home.dart';
import 'package:CovidRelief/boundedContexts/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:CovidRelief/models/user.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:intl/intl.dart';

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

  final databaseReference = Firestore.instance;
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String uid = user.uid;
    return StreamBuilder(
      stream: Firestore.instance.collection("darayuda").where("category", isEqualTo: categoryOfHelp).where("uid", isEqualTo: uid).snapshots(),
      builder: (context, snapshot) {
        DocumentSnapshot helpGiver = snapshot.data.documents[0];
        return WillPopScope(
          onWillPop: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())),
          child: Scaffold(
            backgroundColor: Colors.red[50],
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
                  'Solicitudes de ' + categoryOfHelp,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Open Sans',
                      fontSize: 20),
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

              body: StreamBuilder(
                stream: Firestore.instance.collection('solicitarayuda').where("lastInteraction", isGreaterThanOrEqualTo: DateTime.now().subtract(new Duration(days: 10))).where("category", isEqualTo: categoryOfHelp).snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data.documents.length == 0
                  ? Padding(padding: EdgeInsets.symmetric(vertical: 100.0, horizontal:100), child: Text("No hay solicitudes", style: TextStyle(fontSize: 20.0, color: Colors.grey)),)
                  : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot myPost = snapshot.data.documents[index];
                      return pendingRequests(
                        myPost,
                        myPost['category'], 
                        myPost['code'],
                        myPost['description'], 
                        myPost['email'],
                        myPost['name'], 
                        myPost['phone'],
                        myPost['lastInteraction'],
                        helpGiver['name'],
                        helpGiver['phone'],
                        helpGiver['email'],
                      );
                    }
                  );
                },
              )
          ),
        );
      }
    );}
  }

  // cambia fecha de interaccion
  _updateData(Timestamp lastInteraction, DocumentSnapshot _currentDocument) async {
    await Firestore.instance.collection('solicitarayuda').document(_currentDocument.documentID).updateData({'lastInteraction': DateTime.now()});
  }

  _sendEmail(DocumentSnapshot myPost, String receiver, String sub, String message, String helper, String helperNumber, String helperMail, int code, Timestamp lastInteraction) async {
    _updateData(lastInteraction, myPost);
    
    String mess= "¡Hola!\n\nMi nombre es $helper\nMe gustaría ayudarte con tu petición de ayuda:\n\n $message\n";
    if(helperNumber!=null){
      mess+="\nMi número es $helperNumber";
    }
    if(helperMail!=null){
      mess+="\nMi correo es $helperMail";
    }
    mess+="\n\nTu código para evaluar esta ayuda es $code\n\nSaludos cordiales";
    final String _email = 'mailto:' +
        receiver +
        '?subject=' +
        "Ayuda para tu caso de "+ sub +
        '&body=' +
        mess;
    try {
      await launch(_email);
    } catch (e) {
      throw e.toString();
    }
  }

  _sendWhatsapp(DocumentSnapshot myPost, String phone, String cat, String message, String helper, String helperNumber, String helperMail, int code, Timestamp lastInteraction){
    _updateData(lastInteraction, myPost);
    
    String mess= "¡Hola!\n\nMi nombre es $helper\nMe gustaría ayudarte con tu petición de ayuda en $cat:\n\n $message\n";
    if(helperNumber!=null){
      mess+="\nMi número es $helperNumber";
    }
    if(helperMail!=null){
      mess+="\nMi correo es $helperMail";
    }
    mess+="\n\nTu código para evaluar esta ayuda es $code\n\nSaludos cordiales";

    if(phone.substring(0)=='+'){
      return FlutterOpenWhatsapp.sendSingleMessage(phone, mess);
    }
    if(phone.length > 8){
      return FlutterOpenWhatsapp.sendSingleMessage(phone.substring(3), mess);
    }
    return FlutterOpenWhatsapp.sendSingleMessage('+502$phone', mess);
  }

  Widget pendingRequests(DocumentSnapshot myPost, String category, int code, String description, String email, String name, String phone, Timestamp lastInteraction, String helpGiverName, String helpGiverNumber, String helpGiverMail){
    var formatDate = new DateFormat('d MMM yyyy');
    String fecha = formatDate.format(lastInteraction.toDate());

    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              Text(
                fecha,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey
                ),
                textAlign: TextAlign.left,
              ),
            ],),
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
                  onPressed: ()=>_sendEmail(myPost, email, category, description, helpGiverName, helpGiverNumber, helpGiverMail, code, lastInteraction),
                  child: Text("Enviar correo"),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  shape: StadiumBorder(),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  onPressed: ()=> _sendWhatsapp(myPost, phone, category, description, helpGiverName, helpGiverNumber, helpGiverMail, code, lastInteraction),
                  child: Text("Enviar whatsapp"),
                  textColor: Colors.white,
                  color: Colors.green[300],
                  shape: StadiumBorder(),
                )
              ],
            )
          ],
        ),
      )
    );
}