import 'package:CovidRelief/boundedContexts/PersonalizedHelp/Recieve/HelpForm.dart';
import 'package:CovidRelief/boundedContexts/authenticate/authenticate.dart';
import 'package:CovidRelief/boundedContexts/home/home.dart';
import 'package:CovidRelief/boundedContexts/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/boundedContexts/GeneralHelp/Recieve/ShowPdf.dart';
import 'package:CovidRelief/boundedContexts/GeneralHelp/Give/generalHelp.dart';
import 'package:CovidRelief/boundedContexts/GeneralHelp/Recieve/ShowGeneralHelpPost.dart';
import 'package:CovidRelief/boundedContexts/PersonalizedHelp/Give/GivePersonalizedHelp.dart';
import 'package:CovidRelief/boundedContexts/PersonalizedHelp/Give/HelpRequests.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Help extends StatefulWidget {
  String typeOfHelp;
  String categoryOfHelp;
  Help({this.typeOfHelp, this.categoryOfHelp});

@override
  _Help createState() =>_Help(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp);
}
class _Help extends State<Help>{
  final AuthService _auth = AuthService();

  String typeOfHelp;
  String categoryOfHelp;
  _Help({this.typeOfHelp, this.categoryOfHelp});

  String tituloPantalla(){
    if(typeOfHelp=='quiero ayudar'){
      return '¿Cómo deseas ayudar?';
    }else{
      return '¿Cómo deseas pedir ayuda?';
    }
  }

  String myRatingCode;

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

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

    changeRating(DocumentSnapshot registro, double newVal) async {
      await Firestore.instance.collection('solicitarayuda').document(registro.documentID).updateData({'rating': newVal.toString()});
    }

    Future<void> _sendAnalyticsEventStars() async {
      await analytics.logEvent(
        name: 'five_star_eval'
      );
    }

    Future<void> _sendAnalyticsEventTypeOfHelp(String category, String type, String detail) async {
      await analytics.logEvent(
        name: 'event_'+type.replaceAll(' ', '')+'_'+category+'_'+detail
      );
    }

    starsEval(String code){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder(
            stream: Firestore.instance.collection('solicitarayuda').where("category", isEqualTo: categoryOfHelp).where("code", isEqualTo: int.parse(code)).snapshots(),
            builder: (context, snapshot){
              int codeExists;
              DocumentSnapshot myRequest;
              try{
                codeExists =  snapshot.data.documents.length;
                myRequest = snapshot.data.documents[0];
              }catch(e){
                codeExists = -1;
              }
              // si no existe el codigo se abre una ventana de error
              if(codeExists==-1 || codeExists==0){
                return AlertDialog(
                  title: Text('Código no válido'),
                  content: Text('Por favor ingresa un código válido'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Aceptar'),
                      onPressed: () {Navigator.pop(context);},
                    ),
                  ],
                );
              }else{
                return AlertDialog(
                  title: Text('Calificar ayuda personalizada recibida'),
                  content: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SmoothStarRating(
                          rating: 3.0,
                          size: 30,
                          starCount: 5,
                          allowHalfRating: false,
                          onRated : (value) {
                            if(value==5.0){
                              _sendAnalyticsEventStars();
                            }
                            changeRating(myRequest, value);
                          },
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
              }
            },
          );
      });
    }

    Future<void> _sendAnalyticsEvent() async {
      await analytics.logEvent(
        name: 'eval_personalized_help'
      );
    }

    final _formKey = GlobalKey<FormState>();

    openEval(){ 
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calificar ayuda personalizada recibida'),
            content: Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.code),
                      labelText: 'Ingresa tu código de ayuda recibida',
                    ),
                    validator: (val) => val.isEmpty ? 'Ingrese un código de ayuda' : null,
                    onChanged: (val) {setState(() => myRatingCode = val);},
                  ),)
              ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Evaluar'),
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      _sendAnalyticsEvent();
                      starsEval(myRatingCode);
                    }
                  },
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
                textColor: Colors.white,
                shape: StadiumBorder(),
                color: Colors.blueAccent,
                onPressed: () async {
                  _sendAnalyticsEventTypeOfHelp(categoryOfHelp, typeOfHelp, 'general');
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
                    _sendAnalyticsEventTypeOfHelp(categoryOfHelp, typeOfHelp, 'personal');
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
              height: 170,
            ),
            evalHelp(),
          ],
        ));
  }
}