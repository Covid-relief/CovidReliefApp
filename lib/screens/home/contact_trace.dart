import 'dart:convert';
import 'package:CovidRelief/models/contact.dart';
import 'package:CovidRelief/models/trace.dart';
import 'package:CovidRelief/services/litedatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:http/http.dart';
import 'dart:async';

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
  dynamic user;
  String testText = '';
  final _auth = FirebaseAuth.instance;

  //Turn button green
  bool _hasBeenPressed = false;


  String _uid;
  String _email;

  void getCurrentUserInfo() async {
    user = await auth.currentUser();
    _uid = await user.uid;
    _email= await user.email;
  }

  _makeContactsRequest() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    List<Trace> contacts= await DBProvider.db.getAllTraces();

    Contact contact = new Contact(user: _email, key: _uid,day: formatted, traces: contacts);
    Map<String, dynamic> map = contact.toJson();

    // set up POST request arguments
    String url = 'http://ec2-18-216-89-33.us-east-2.compute.amazonaws.com/contact';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(map);
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    // this API passes back the id of the new item added to the body
    String body = response.body;
    print(body);

    await DBProvider.db.deleteAllTraces();
  }

  _makeNotifyRequest() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    List<Trace> contacts= await DBProvider.db.getAllTraces();

    if(contacts.isNotEmpty){
      Contact contact = new Contact(user: _email, key: _uid,day: formatted, traces: contacts);
      Map<String, dynamic> map = contact.toJson();
      String json = jsonEncode(map);
    }
    else{
      Contact contact = new Contact(user: _email, key: _uid,day: formatted);
      Map<String, dynamic> map = contact.toJson();
      String json = jsonEncode(map);

    }

    // set up POST request arguments
    String url = 'http://ec2-18-216-89-33.us-east-2.compute.amazonaws.com/notify';
    Map<String, String> headers = {"Content-type": "application/json"};

    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    // this API passes back the id of the new item added to the body
    String body = response.body;
    print(body);

    await DBProvider.db.deleteAllTraces();
  }

  void discovery() async {

    try {
      bool a = await Nearby().startDiscovery(loggedInUser.uid, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an uid

        //  When I discover someone I will see their uid and add that uid to the database of my contacts
        //  also get the current time and add it to the database
        var newTrace= Trace(userid: await getUsernameOfUID(uid: name),contactTime: DateTime.now());
         //ADDING TRACE TO SQLite
        DBProvider.db.addTrace(newTrace);

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
        future: DBProvider.db.getAllTraces(),
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
                        _makeNotifyRequest();
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

