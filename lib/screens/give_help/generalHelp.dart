import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:flutter/material.dart';

class PostHelp extends StatefulWidget {

  @override
  _PostHelpState createState() => _PostHelpState();
}

class _PostHelpState extends State<PostHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.teal[50],
          appBar: AppBar(
            title: Text('Consejo general',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Open Sans',
                  fontSize: 25),),
            backgroundColor: Colors.lightBlue[900],
            elevation: 0.0,),
            body: ListView(
              children: <Widget>[
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Text('Keywords: ')
                ),
                Row(
                  children: <Widget>[
                  // aca va el feature de las keywords
                  ],
                ),
                SizedBox(height: 30.0),
                Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Titulo'),
                    ),
                ),
                SizedBox(height: 30.0),
                Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child:TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      decoration: textInputDecoration.copyWith(hintText: 'Escribe tu consejo... (opcional)'),
                      //contentPadding: new EdgeInsets.fromLTRB(15, 0, 0, 200),
                    ),
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Text('Adjuntos (opcional)')
                ),
                SizedBox(height: 20.0),
                Column(children: <Widget>[
                  Row(children: <Widget>[
                  // button to submit links
                  SizedBox(
                    width: 110,
                    child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.insert_link,
                      size: 24,
                    ),
                    //padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    shape: CircleBorder(),
                  ),
                  ),

                  // button to submit images
                  
                  SizedBox(
                    width: 75,
                    child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 24,
                    ),
                    //padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    shape: CircleBorder(),
                  ),
                  ),

                  // button to submit videos

                  SizedBox(
                    width: 75,
                    child: MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.video_library,
                      size: 24,
                    ),
                    //padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    shape: CircleBorder(),
                  ),
                  ),

                  // button to submit documents
                  SizedBox(
                    width: 110,
                    child:MaterialButton(
                    onPressed: () {},
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.archive,
                      size: 24,
                    ),
                    //padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                  ),
                  ),

                ],),
                Row(children: <Widget>[
                  // link text
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Text('Link')
                  ),
                  // image text
                  Container(
                    padding: EdgeInsets.fromLTRB(58, 0, 0, 0),
                    child: Text('Imagen')
                  ),
                  // video text
                  Container(
                    padding: EdgeInsets.fromLTRB(33, 0, 0, 0),
                    child: Text('Video')
                  ),
                  // documenttext
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Text('Documento')
                  ),
                ],)
                ],),
                
                // falta boton de enviar
              ],
            )
      );
  }
}