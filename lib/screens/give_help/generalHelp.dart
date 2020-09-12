import 'package:CovidRelief/screens/authenticate/authenticate.dart';
import 'package:CovidRelief/screens/home/home.dart';
import 'package:CovidRelief/screens/home/user_profile.dart';
import 'package:CovidRelief/services/auth.dart';
import 'package:CovidRelief/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:CovidRelief/screens/give_help/uploadFiles.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class PostHelp extends StatefulWidget {
  String typeOfHelp;
  String categoryOfHelp;
  PostHelp({this.typeOfHelp, this.categoryOfHelp});

  @override
  _PostHelpState createState() => _PostHelpState(typeOfHelp:typeOfHelp, categoryOfHelp:categoryOfHelp);
}

class _PostHelpState extends State<PostHelp> {
  String typeOfHelp;
  String categoryOfHelp;
  _PostHelpState({this.typeOfHelp, this.categoryOfHelp});

  final _formKey = GlobalKey<FormState>();
  String titulo;
  String descripcion;
  String categoria;
  List <String> keywords;
  File video;
  File archivo;
  String link; // ya veremos
  String username; // ya veremos
  File sampleImage;

  Future getImage()async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      sampleImage = tempImage;
    });
  }

  Future pickVideo() async {
    File myVideo = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      video = myVideo; 
      //videoPlayerControl.play();
    });
}

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
            body: Form(
              key:_formKey,
              child: ListView(
                children: <Widget>[
                  /* Feature para el siguiente sprint
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
                  */
                  SizedBox(height: 30.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Titulo'),
                        validator: (valtitulo){return valtitulo.isEmpty ? 'Escribir un titulo': null;},
                        onChanged: (valtitulo) => setState(() => titulo = valtitulo),
                      ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child:TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 15,
                        decoration: textInputDecoration.copyWith(hintText: 'Escribe tu consejo... (opcional)'),
                        onChanged: (valtdesc) => {if (valtdesc!=null) {setState(() => descripcion = valtdesc)}else{setState(() => descripcion = 'none')}},
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
                      onPressed: () {print('Tipo de consulta '+typeOfHelp.toString()+' categoria '+ categoryOfHelp.toString());},
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
                      onPressed: () => getImage(),
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
                      onPressed: ()  => pickVideo(),
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
                  
                  SizedBox(height: 30.0),
                  Container(
                    child: imageUp(sampleImage),
                  ),

                  Container(
                    child: Center(
                      child: videoUp(video).value.initialized
                          ? AspectRatio(
                              aspectRatio: videoUp(video).value.aspectRatio,
                              child: VideoPlayer(videoUp(video)),
                            )
                          : Container(),
                    ),
                  ),
                  
                  // arreglar el display. 
                  RaisedButton(
                    elevation: 10.0,
                    color: Colors.teal,
                    child: Text(
                      'Publicar',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if(_formKey.currentState.validate()){
                        // update the data in the DB
                        print('Enviando ' + titulo.toString() + descripcion.toString() + sampleImage.toString());
                        uploadFiles(
                          titulo, 
                          descripcion, 
                          categoryOfHelp, 
                          keywords, 
                          video, 
                          archivo, 
                          link, 
                          username, 
                          sampleImage);

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                      }
                    } // onPressed
                    
                    //
                  ),
                ],
            ),
          )
      );
  }
}