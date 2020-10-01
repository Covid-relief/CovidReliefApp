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
import 'package:flutter_document_picker/flutter_document_picker.dart';


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
  String link;
  String username; // ya veremos
  File sampleImage;

  // change color when something uploaded
  Color styleArchivo (archivo) {
    Color color;
    if (archivo!=null) {
      color=Colors.green;
    }else{
      color=Colors.blue;
    }
    return color;
  }


  // set image
  Future getImage()async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      sampleImage = tempImage;
    });
  }

  // set video
  Future pickVideo() async {
    File myVideo = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      video = myVideo; 
      //videoPlayerControl.play();
    });
  }

  // set file
  Future pickFile() async{
    // types: pdf, csv, docx, doc, xslx, xsl, ppt, pub, txt
    final params = FlutterDocumentPickerParams(     
      //allowedFileExtensions: ['pdf', 'csv', 'docx', 'doc', 'xslx', 'xsl', 'ppt', 'pub', 'txt'],
      allowedMimeTypes: ['application/*'],
      //allowedMimeTypes: ['application/pdf', 'text/csv', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
      //  'application/msword', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/vnd.ms-excel',
      //  'application/vnd.ms-powerpoint', 'application/x-mspublisher', 'text/plain'],
    );

    final myFile = await FlutterDocumentPicker.openDocument(params: params);
    var newFile = new File(myFile).writeAsString(myFile);
    File data = await newFile;

    setState(() {
      archivo = data; 
    });
  }

  // set link
  openPopup(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adjuntar link'),
          content: Stack(
            children: <Widget>[
              Container(
                child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.insert_link),
                      labelText: 'Ingresa tu link',
                    ),
                  onChanged: (valLink) => setState(() {link = valLink;}),
                  ),
              ),
            ],),
            actions: <Widget>[
              FlatButton(
                child: Text('Enviar'),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
        );
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
                        decoration: textInputDecoration.copyWith(hintText: 'Título'),
                        validator: (valtitulo){return valtitulo.isEmpty ? 'Escribir un título': null;},
                        onChanged: (valtitulo) => setState(() => titulo = valtitulo),
                      ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child:TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 12,
                        decoration: textInputDecoration.copyWith(hintText: 'Escribe tu consejo... (opcional)'),
                        onChanged: (valtdesc) => {if (valtdesc!=null) {setState(() => descripcion = valtdesc)}else{setState(() => descripcion = null)}},
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                    // button to submit links
                      SizedBox(
                      width: 90,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                          onPressed: () async {openPopup();},
                          color: styleArchivo(link),
                          textColor: Colors.white,
                          child: Icon(
                            Icons.insert_link,
                            size: 24,
                          ),
                          shape: CircleBorder(),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text('Link')
                        ),
                      ],)
                    ),

                    // button to submit files
                      SizedBox(
                      width: 90,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () => pickFile(),
                            color: styleArchivo(archivo),
                            textColor: Colors.white,
                            child: Icon(
                              Icons.archive,
                              size: 24,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: Text('Documento')
                        ),
                        ],
                      )
                    ),

                    // button to submit images
                    SizedBox(
                      width: 90,
                      child: Column(
                        children: <Widget>[
                          MaterialButton(
                            onPressed: ()  => getImage(),
                            color: styleArchivo(sampleImage),
                            textColor: Colors.white,
                            child: Icon(
                              Icons.add_photo_alternate,
                              size: 24,
                            ),
                            shape: CircleBorder(),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: Text('Imagen')
                          ),
                        ],
                      )
                    ),

                    // button to submit documents
                    SizedBox(
                      width: 90,
                      child: Column(children: <Widget>[
                        MaterialButton(
                          onPressed: () => pickVideo(),
                          color: styleArchivo(video),
                          textColor: Colors.white,
                          child: Icon(
                            Icons.video_library,
                            size: 24,
                          ),
                          shape: CircleBorder(),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text('Video')
                        ),
                      ],
                      )
                    ),

                  ],),
                  ],),
                  
                  SizedBox(height: 40.0),
                  Container(
                    child: imageUp(sampleImage),
                  ),
                  SizedBox(height: 15.0),

                  // no esta funcionando
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
                  Container(
                    height: 70,
                    padding: EdgeInsets.fromLTRB(70,0,70,0),
                    child:
                    RaisedButton(
                        elevation: 5.0,
                        color: Colors.teal,
                        shape: StadiumBorder(),
                        child: Text(
                          'Publicar',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){
                            // update the data in the DB
                            print('Enviando ' + titulo.toString());
                            uploadFiles(
                                titulo,
                                descripcion,
                                categoryOfHelp,
                                keywords,
                                video,
                                archivo,
                                link,
                                username,
                                sampleImage,
                                "evaluate");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
                      }
                    } // onPressed
                    ),
                  ),
                ],
            ),
          )
      );
  }
}