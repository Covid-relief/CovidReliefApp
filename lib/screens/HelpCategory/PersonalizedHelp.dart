import 'package:CovidRelief/screens/PersonalizedHelp/HelpForm.dart';
import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/HelpCategory/ShowPdf.dart';
import 'package:CovidRelief/screens/give_help/generalHelp.dart';
import 'package:CovidRelief/screens/HelpCategory/ShowGeneralHelpPost.dart';
import 'package:CovidRelief/screens/PersonalizedHelp/GivePersonalizedHelp.dart';
import 'package:CovidRelief/screens/PersonalizedHelp/HelpRequests.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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

  var rating = 3.0;

  @override
  // State<StatefulWidget> createState() {
  Widget build(BuildContext context) {

    Widget showMyGuide(){
      if (typeOfHelp=='quiero ayudar'){
        return GestureDetector(
          child: Text("Guía para dar consejos generales",
              textAlign: TextAlign.center,
              style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
          onTap: () async {Navigator.push(context,MaterialPageRoute(builder: (context) => PDF()),);
      });
      }else{
        return SizedBox();
      }
    }

    starsEval(String code){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calificar ayuda personalizada recibida'),
            content: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SmoothStarRating(
                    rating: rating,
                    size: 30,
                    starCount: 5
                  ),
                  ],
                ),
              ],),
              actions: <Widget>[
                FlatButton(
                  child: Text('Enviar'),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);},
                ),
              ],
          );
      });
    }

    openEval(){ 
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calificar ayuda personalizada recibida'),
            content: Stack(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.code),
                    labelText: 'Ingresa tu código de ayuda recibida',
                  ),
                onChanged: null,
                ),
              ],),
              actions: <Widget>[ // checar si el codigo existe
                FlatButton(
                  child: Text('Evaluar'),
                  onPressed: () {starsEval("code");},
                ),
              ],
          );
      });
    }

    Widget evalHelp(){
      if(typeOfHelp!='quiero ayudar'){
        return Row(children: <Widget>[
          FlatButton.icon(
          color: Colors.yellow[600],
          icon: Icon(Icons.star_half),
          label: Text('Evaluar ayuda recibida'),
          onPressed: () => openEval(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        );
      }else{
        return SizedBox();
      }
    }

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
          //backgroundColor: Colors.lightBlue[900],
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
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            Container(height: 50),
            Container(
              height: 90,
              child: new Center(child: Text(tituloPantalla(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            Container(
              height: 20,
            ),
            Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                //elevation: 5.0,
                textColor: Colors.white,
                shape: StadiumBorder(),
                color: Colors.blueAccent,
                onPressed: () async {
                  if(typeOfHelp=='quiero ayudar'){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostHelp(typeOfHelp: typeOfHelp, categoryOfHelp: categoryOfHelp)),);
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPosts(categoryOfHelp: categoryOfHelp),));
                  }
                },
                child: Text("Tips y consejos generales",
                    style: TextStyle(fontSize: 19),
                    textAlign: TextAlign.center),
              ),
            ),
            Container(
              height: 15.0,
            ),
            showMyGuide(),
            Container(
              height: 35,
            ),
            Container(
              height: 70,
              padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
              child: RaisedButton(
                  padding: const EdgeInsets.all(2.0),
                  textColor: Colors.white,
                  //elevation: 5.0,
                  color: Colors.blueAccent,
                  shape: StadiumBorder(),
                  onPressed: () async {
                    if(typeOfHelp!='quiero ayudar'){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => HelpForm(categoryOfHelp:categoryOfHelp)),);
                    }else{
                      Navigator.push(context,MaterialPageRoute(builder: (context) => GivePersonalizedHelp(categoryOfHelp:categoryOfHelp)),);
                    }
                  },
                  child: Text("Apoyo personalizado y contacto personal",
                      style: TextStyle(fontSize: 17),
                      textAlign: TextAlign.center)),
            ),
            Container(
              height: 200,
            ),
            evalHelp(),
          ],
        ));
  }
}