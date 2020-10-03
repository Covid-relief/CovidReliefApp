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
import 'package:linkable/linkable.dart';
import 'package:url_launcher/url_launcher.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  var typeOfHelp;

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' No se puede obtener $command');
    }
  }

  @override
  Widget build(BuildContext context) {


    // void _showSettingsPanel(){
    //   showModalBottomSheet(context: context, builder: (context){
    //     return Container(
    //       padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
    //       child:  UserDataForm(),
    //     );
    //   });
    // }
    return StreamProvider<List<Perfiles>>.value(
        value: DatabaseService().perfiles,
          //child: Container(
          child: Scaffold(
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
              title: Text('Covid Relief',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 25),
              ),
              //backgroundColor:  Colors.lightBlue[900],
              elevation: 0.0,),
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
                  title: Text('Perfil',),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                  },
                ),
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
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(child: Text('Te recordamos que esta es una plataforma facilitada por la Universidad '
                          'Francisco Marroquín pero de ninguna manera es responsable de los consejos e ideas aquí presentadas '
                          'y el éxito o fracaso de los mismos.',
                           textAlign: TextAlign.center,
                           style: TextStyle(height: 1.3),
                        )
                      ),
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
                          //elevation: 5.0,
                          color: Colors.blueAccent,
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
                        //elevation: 5.0,
                        color: Colors.blueAccent,
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
                          Column(
                            children: <Widget>[
                              MaterialButton(
                                onPressed: null,
                                color: Colors.red,
                                textColor: Colors.red,
                                child: Icon(
                                  Icons.info,
                                  size: 40
                                ),
                                  shape: CircleBorder(),
                                ),
                              SizedBox(height: 5.0),
                              Container(
                                child: Text('Conferencias')
                              ),
                            ],
                          ),

                          Column(children: <Widget>[
                            MaterialButton(
                              onPressed: null,
                              color: Colors.red,
                              textColor: Colors.red,
                              child: Icon(
                                Icons.live_tv,
                                size: 40
                              ),
                                shape: CircleBorder(),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                child: Text('Noticias')
                              ),
                            ],)
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(50,0,50,0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Para comunicarte con la facultad de medicina UFM, '
                                'llama al siguiente número\n', textAlign: TextAlign.center,),
                            SizedBox(
                              width: 240,
                              height: 70,
                              child: RaisedButton.icon(
                                  padding: const EdgeInsets.all(2.0),
                                  textColor: Colors.white,
                                  //elevation: 5.0,
                                  color: Colors.green,
                                  shape: StadiumBorder(),
                                  //FlatButton.icon(onPressed: () => launch("tel://+502 2413 3235"), icon: Icon(Icons.call), label: Text("Call")),
                                  onPressed: () {
                                    customLaunch('tel:+502 2413 3235');
                                  },
                                  label: Text('2413 3235', style: TextStyle(fontSize: 20),),
                                  icon: Icon(Icons.phone)

                              ),
                            )
                            ,
                          ],
                        )
                    )
                  ],
                )
        ),
    );
  }
}