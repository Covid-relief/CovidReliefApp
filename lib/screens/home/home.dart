import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/contact_trace.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/screens/HelpCategory/HelpCategories.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  var typeOfHelp;

  @override
  Widget build(BuildContext context) {


    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child:  UserDataForm(),
        );
      });
    }
    return StreamProvider<List<Perfiles>>.value(
        value: DatabaseService().perfiles,
          //child: Container(
          child: Scaffold(
            backgroundColor: Colors.teal[50],
            appBar: AppBar(
              title: Text('Covid Relief',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 25),
              ),
              backgroundColor:  Colors.lightBlue[900],
              elevation: 0.0,),
           drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[900],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
                //FlatButton.icon(
                //  icon : Icon(Icons.settings),
                 // label: Text("Configuración"),
                 // onPressed:() => _showSettingsPanel(),
               // ),
               ListTile(
                  leading: Icon(Icons.track_changes),
                  title: Text('Contact Trace',),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyInterface()),);
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
                    Container(
                      height: 80,
                      child: const Center(child: Text('Bienvenido a COVID-19 Relief', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      height: 130,
                      padding: EdgeInsets.fromLTRB(25,0,25,0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
                          'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
                          'y el éxito o fracaso de los mismos.',
                           textAlign: TextAlign.center,
                      )),
                    ),
                    Container(
                      height: 40,
                    ),
                    Container(
                      height: 70,
                      padding: EdgeInsets.fromLTRB(70,0,70,0),
                      child:
                      RaisedButton(
                          padding: const EdgeInsets.all(2.0),
                          textColor: Colors.white,
                          elevation: 5.0,
                          color: Colors.teal,
                          shape: StadiumBorder(),
                          onPressed:() {
                            typeOfHelp='quiero ayudar';
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Category(typeOfHelp:typeOfHelp)),);
                          },
                          child: new Text("Quiero ayudar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Open Sans',)
                          ),
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
                        elevation: 5.0,
                        color: Colors.teal,
                        shape: StadiumBorder(),
                        onPressed:() {
                          typeOfHelp='necesito ayuda';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Category(typeOfHelp:typeOfHelp)),);
                        },
                        child: new Text("Necesito ayuda",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Open Sans',),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              onPressed: null,
                              elevation: 5.0,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                              child: new Text("Conferencias", style: TextStyle(color: Colors.white))
                          ),
                          RaisedButton(
                              onPressed: null,
                              elevation: 5.0,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              child: new Text(" Noticias ", style: TextStyle(color: Colors.white))
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(50,0,50,0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Para comunicarte con la facultad de medicina UFM, '
                                'llama al siguiente número', textAlign: TextAlign.center,),
                            RichText(text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.phone)),
                              TextSpan(
                                text: '  2413 3235',
                                style: TextStyle(color: Colors.black),
                              )
                            ]
                          ))
                          ],
                        )
                    )
                  ],
                )
          // personal data from settings_form.dart
             //HAY QUE DESARROLLAR EL HOME
            // redirect to user profile
            //UserProfile(), //UserList(), 
        ),
    );
  }
}