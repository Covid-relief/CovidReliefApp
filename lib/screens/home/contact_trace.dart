import 'dart:developer';

import 'package:CovidRelief/models/trace.dart';
import 'package:CovidRelief/services/litedatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:http/http.dart';

import 'package:crypto/crypto.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:convert';

import 'components/contact_card.dart';
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
  List<dynamic> contactTraces = [];
  List<dynamic> contactTimes = [];
  List<dynamic> contactLocations = [];
  List<Map<String, dynamic>> contacts;
  // List<String> contacts = List<String>();
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


  void addContactsToList() async {
    await getCurrentUser();

    _firestore
        .collection('users')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
        String currUsername = doc.data['username'];
        DateTime currTime = doc.data.containsKey('contact time')
            ? (doc.data['contact time'] as Timestamp).toDate()
            : null;
        String currLocation = doc.data.containsKey('contact location')
            ? doc.data['contact location']
            : null;
        if (!contactTraces.contains(currUsername)) {
          contactTraces.add(currUsername);
          contactTimes.add(currTime);
          contactLocations.add(currLocation);
        }
      }
      setState(() {});
      print(loggedInUser.email);
    });
  }

  void deleteOldContacts(int threshold) async {
    await getCurrentUser();
    DateTime timeNow = DateTime.now(); //get today's time

    _firestore
        .collection('users')
        .document(loggedInUser.email)
        .collection('met_with')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.documents) {
//        print(doc.data.containsKey('contact time'));
        if (doc.data.containsKey('contact time')) {
          DateTime contactTime = (doc.data['contact time'] as Timestamp)
              .toDate(); // get last contact time
          // if time since contact is greater than threshold than remove the contact
          if (timeNow.difference(contactTime).inDays > threshold) {
            doc.reference.delete();
          }
        }
      }
    });

    setState(() {});
  }

  void discovery() async {
/*    final Future<Database> database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'contacts.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          //TODO if contacts null create
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY, contact TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );*/

    /*Future<void> saveContact(Map contact) async {
      // Get a reference to the database.
      final Database db = await database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'contacts',
        contact,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }*/

    try {
      bool a = await Nearby().startDiscovery(loggedInUser.email, strategy,
          onEndpointFound: (id, name, serviceId) async {
        print('I saw id:$id with name:$name'); // the name here is an email
        var timestamp = DateTime.now();
        var contact = '{"key":$name, "timestamp":"$timestamp"}';
        // var contact = {'key': name, 'timestamp': DateTime.now()};
        // contacts.add({'contact': contact});
        // await saveContact({'contact': contact});

        var newTrace= Trace(id: id, userid: name,contactTime: timestamp);
        db.addTrace(newTrace); //ADDING TRACE TO SQLite

        var docRef =
            _firestore.collection('users').document(loggedInUser.email);

        //  When I discover someone I will see their email and add that email to the database of my contacts
        //  also get the current time & location and add it to the database
        docRef.collection('met_with').document(name).setData({
          //'name': await getUsernameOfEmail(email: name),
          'username': await getUsernameOfEmail(),
          'contact time': DateTime.now(),
          'contact location': (await location.getLocation()).toString(),
        });
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

  Future<String> getUsernameOfEmail({String email}) async {
    String res = '';
    await _firestore.collection('users').document(email).get().then((doc) {
      if (doc.exists) {
        res = doc.data['name'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        await _firestore.collection('users').document(user.email).setData(
            {
          'username': user.email,
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
    deleteOldContacts(14);
    addContactsToList();
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
                              'Your Contact Traces',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 21.0,
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
                          loggedInUser.email,
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
                      'Start Tracing',
                      style: kButtonTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ContactCard(
                          imagePath: 'images/profile1.jpg',
                          //email: contactTraces[index]+"*****",
                          //email: "********"+contactTraces[index].substring((contactTraces[index].length/2).toInt(),contactTraces[index].length),
                          email:
                          "${sha1.convert(utf8.encode(contactTraces[index]))}",
                          // data being hashed
                          infection: 'Not-Infected',
                          contactUsername: contactTraces[index],
                          contactTime: contactTimes[index],
                          contactLocation: contactLocations[index],
                        );
                      },
                      itemCount: contactTraces.length,
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
