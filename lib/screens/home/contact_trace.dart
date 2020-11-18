import 'package:CovidRelief/models/signup.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;

  String testText = '';
  final _auth = FirebaseAuth.instance;
  DBProvider db= DBProvider(); //create SQLite database


  bool _hasBeenPressed = false;

  _makePostRequest() async {
    // set up POST request arguments
    String url = 'https://jsonplaceholder.typicode.com/posts';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"user":"lindseydelaroca@ufm.edu","key":"10c8dde1b7417b76de55465169fd4fa3","day":"2020-11-16","contacts": [{"key":"98191d4ef294b24de30b55cef2d62726", "timestamp":"2020-10-23T16:19:12"},{"key":"45ee479816aba875127e1c2a84d341fd", "timestamp":"2020-10-22T15:24:52"},{"key":"3c3775565679380036998edb4cbb4c8a", "timestamp":"2020-10-21T13:24:12"},{"key":"e992ca593dca3fdff71c01c10bb23c0a", "timestamp":"2020-10-21T13:24:12"}]} ';
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

        //  When I discover someone I will see their uid and add that uid to the database of my contacts
        //  also get the current time and add it to the database
        var newTrace= Trace(userid: await getUsernameOfUID(uid: name),contactTime: DateTime.now());
        db.addTrace(newTrace); //ADDING TRACE TO SQLite

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
      FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;
      if (user != null) {
        await _firestore.collection('users').document(uid).setData(
            {
          'username': uid,
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
    getCurrentUser();
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
              ],
            ),
      ),
      body: FutureBuilder(
        future: db.initDB(),
        builder: (BuildContext context,snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 30,
                  ),
                  Container(
                    height: 160,
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                            'Ayuda a detener la propagación de COVID-19',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 19.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(2.0),
                      shape: StadiumBorder(),
                      //elevation: 5.0,
                      color:  _hasBeenPressed ? Colors.green : Colors.blue[300],
                      onPressed: () async {
                        setState(() {
                          _hasBeenPressed = !_hasBeenPressed;
                        });

                        if(_hasBeenPressed){
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

                            //_makePostRequest(); //POST
                          } catch (e) {
                            print(e);
                          }
                          discovery();
                        }
                      },
                      child: Text(
                        'Empezar a rastrear contactos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                    child: RaisedButton(
                      shape:  StadiumBorder(),
                      //elevation: 5.0,
                      color: Colors.blue[300],
                      onPressed: () async {
                      },
                      child: Text(
                        'Comunica tu resultado positivo a COVID-19',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Open Sans',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                ],
              ),
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

