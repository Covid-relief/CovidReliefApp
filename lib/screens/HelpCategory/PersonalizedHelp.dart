import 'package:CovidRelief/screens/HelpCategory/HelpForm.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/HelpCategory/ShowPdf.dart';


import 'package:CovidRelief/screens/give_help/generalHelp.dart';

import 'package:CovidRelief/screens/HelpCategory/ShowPdf.dart';

class Help extends StatelessWidget {
  final AuthService _auth = AuthService();


  String typeOfHelp;
  String categoryOfHelp;
  Help({this.typeOfHelp, this.categoryOfHelp});

  String tituloPantalla(){
    if(typeOfHelp=='quiero ayudar'){
      return '¿Cómo deseas ayudar?';
    }else{
      return '¿Cómo deseas pedir ayuda?';
    }
  }

    @override
    // State<StatefulWidget> createState() {
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Covid Relief',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 25),),
            backgroundColor: Colors.lightBlue[900],
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
                child: new Center(child: Text(tituloPantalla(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),

  @override
  // State<StatefulWidget> createState() {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Covid Relief',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 25),
          ),

class Help extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  // State<StatefulWidget> createState() {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Covid Relief',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 25),
          ),

          backgroundColor: Colors.lightBlue[900],
          elevation: 0.0,
        ),
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


              Container(
                height: 120,
                padding: EdgeInsets.fromLTRB(70,0,70,0),
                child:
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  textColor: Colors.white,
                  color: Colors.teal[200],
                  onPressed:() async {
                    if(typeOfHelp=='quiero ayudar'){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostHelp(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp)),);
                    }
                  },
                  child: Text("Tips y consejos generales", style: TextStyle(fontSize: 20), textAlign: TextAlign.center),


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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                },

              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            Container(
              height: 90,
              child: const Center(
                  child: Text('¿Cómo deseas ayudar?',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            Container(
              height: 20,
            ),
            Container(
              height: 120,
              padding: EdgeInsets.fromLTRB(70, 0, 70, 5),
              child: RaisedButton(
                padding: const EdgeInsets.all(0.0),
                textColor: Colors.white,
                color: Colors.teal[200],
                onPressed: () async {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ),);
                },
                child: Text("Tips y consejos generales",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),

              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            Container(
              height: 90,
              child: const Center(
                  child: Text('¿Cómo deseas ayudar?',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            Container(
              height: 20,
            ),
            Container(
              height: 120,
              padding: EdgeInsets.fromLTRB(70, 0, 70, 5),
              child: RaisedButton(
                padding: const EdgeInsets.all(0.0),
                textColor: Colors.white,
                color: Colors.teal[200],
                onPressed: () async {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ),);
                },
                child: Text("Tips y consejos generales",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
              ),

            ),
            GestureDetector(
                child: Text("Guía para dar consejos generales",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue)),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDF()),
                  );
                  // do what you need to do when "Click here" gets clicked
                }),
            Container(
              height: 20,
            ),
            Container(
              height: 120,
              padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  textColor: Colors.white,
                  color: Colors.teal[200],
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HelpForm()),
                    );
                  },
                  child: Text("Apoyo personalizado y contacto personal",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center)),
            ),
            Container(
              height: 90,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Para comunicarte con la facultad de medicina UFM, '
                    'llama al siguiente número',
                    textAlign: TextAlign.center,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.phone)),
                    TextSpan(
                      text: '  2413 3235',
                      style: TextStyle(color: Colors.black),
                    )
                  ]))
                ],
              ),
            ),
          ],
        ));
  }
}
