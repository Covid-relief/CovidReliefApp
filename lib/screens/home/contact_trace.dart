import 'dart:developer';

import 'package:CovidRelief/models/trace.dart';
import 'package:CovidRelief/services/litedatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'constants.dart';

class NearbyInterface extends StatefulWidget {
  static const String id = 'nearby_interface';

  @override
  _NearbyInterfaceState createState() => _NearbyInterfaceState();
}

class _NearbyInterfaceState extends State<NearbyInterface> {
  Location location = Location();
  Firestore _firestore = Firestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  FirebaseUser loggedInUser;

  String testText = '';
  final _auth = FirebaseAuth.instance;
  DBProvider db= DBProvider(); //create SQLite database

  _makePostRequest() async {
    // set up POST request arguments
    String url = 'https://jsonplaceholder.typicode.com/posts';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"title": "Hello", "body": "body text", "userId": 1}';
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }
  }

  void discovery() async {
    try {
      bool a = await Nearby().startDiscovery(loggedInUser.uid, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an uid
        var timestamp = DateTime.now();
        var newTrace= Trace(userid: name,contactTime: timestamp);


        //  When I discover someone I will see their uid and add that uid to the database of my contacts
        //  also get the current time and add it to the database
        db.addTrace(newTrace, name); //ADDING TRACE TO SQLite

          }, onEndpointLost: (id) {
        print(id);
      });
      print('DISCOVERING: ${a.toString()}');
    } catch (e) {
      print(e);
    }
  }

  /*void checkWifiAndParse() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      final Future<Database> db =
          openDatabase(join(await getDatabasesPath(), 'contacts.db'));

      final List<Map<String, dynamic>> maps = await db.query('contacts');
    } else {
      print("Error: Connected to internet but not to WiFi");
    }
  }*/

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  Future<String> getUsernameOfUID({String uid}) async {
    String res = '';
    await _firestore.collection('users').document(uid).get().then((doc) {
      if (doc.exists) {
        res = doc.data['username'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  //Save the current user uid
  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        await _firestore.collection('users').document(user.uid).setData(
            {
          'username': user.uid,
        });
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Trace'),
        //backgroundColor: Colors.cyan[700],
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
                  leading: Icon(Icons.home),
                  title: Text('Inicio',),
                  onTap: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Cerrar Sesión'),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'Inicio',
                  ),
                  onTap: () async {
                    Navigator.pushReplacement(
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
                    Navigator.pushReplacement(
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Authenticate()),
                    );
                  },
                ),
              ],
            ),
      ),
      body: FutureBuilder(
        future: db.initDB(),
        builder: (BuildContext context,snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      bottom: 10.0,
                      top: 30.0,
                    ),
                    child: Container(
                      height: 100.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(20.0),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black,
                        //     blurRadius: 4.0,
                        //     spreadRadius: 0.0,
                        //     offset:
                        //         Offset(2.0, 2.0), // shadow direction: bottom right
                        //   )
                        // ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Image(
                              image: AssetImage('images/corona.png'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Tus trazas de contactos',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 19.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 5.0,
                    color: Colors.blue[300],
                    onPressed: () async {
                      try {
                        bool a = await Nearby().startAdvertising(
                          loggedInUser.uid,
                          strategy,
                          onConnectionInitiated: null,
                          onConnectionResult: (id, status) {
                            print(status);
                          },
                          onDisconnected: (id) {
                            print('Disconnected $id');
                          },
                        );

                        print('ADVERTISING ${a.toString()}');

                        _makePostRequest(); //POST
                      } catch (e) {
                        print(e);
                      }

                      discovery();
                    },
                    child: Text(
                      'Empezar a rastrear contactos',
                      style: kButtonTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 5.0,
                    color: Colors.blue[300],
                    onPressed: () async {
                    },
                    child: Text(
                      'Comunica tu positivo a COVID-19',
                      style: kButtonTextStyle,
                    ),
                  ),
                ),
              ],
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// TODO: Take mobile number instead of email

// TODO: Delete contacts older than 14 days from database
