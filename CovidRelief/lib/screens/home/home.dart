import 'package:CovidRelief/models/profile.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:provider/provider.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child:  SettingsForm(),
        );
      });
    }
    return StreamProvider<List<Perfiles>>.value(
        value: DatabaseService().perfiles,
          //child: Container(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('CovidRelief'),
              backgroundColor: Colors.red[400],
              elevation: 0.0,),
           drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
                //FlatButton.icon(
                //  icon : Icon(Icons.settings),
                 // label: Text("Configuración"),
                 // onPressed:() => _showSettingsPanel(),
               // ),
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
            body:
                ListView(
                  padding: const EdgeInsets.all(15),
                  children: <Widget>[
                    Container(
                      height: 90,
                      child: const Center(child: Text('Bienvenido a COVID-19 Relief', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      height: 120,
                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                      decoration: BoxDecoration(
                        color: Colors.cyan[400],
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
                      height: 50,
                      padding: EdgeInsets.fromLTRB(50,0,50,0),
                      child:
                      RaisedButton(
                          padding: const EdgeInsets.all(2.0),
                          textColor: Colors.white,
                          color: Colors.orangeAccent[700],
                          onPressed:() {},
                          child: new Text("Quiero ayudar"),
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(50,0,50,0),
                      child:
                      RaisedButton(
                        padding: const EdgeInsets.all(2.0),
                        textColor: Colors.white,
                        color: Colors.orangeAccent[700],
                        onPressed:() {},
                        child: new Text("Necesito ayuda"),
                      ),
                    ),
                    Container(
                      height: 60,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              onPressed: null,
                              shape: StadiumBorder(),
                              child: new Text("Conferencias", style: TextStyle(color: Colors.black))
                          ),
                          RaisedButton(
                              onPressed: null,
                              shape: StadiumBorder(),
                              child: new Text("Noticias", style: TextStyle(color: Colors.black))
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