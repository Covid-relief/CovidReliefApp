import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:CovidRelief/screens/give_help/postToDB.dart';


/**
 * Aqui basicamente hacemos widgets para mostrar los files y hacemos conexion con la subida de datos (que esta en postToDB.dart)
 */
Widget imageUp (sampleImage){
  if (sampleImage!=null){
    return Image.file(sampleImage);
  }else{
    return SizedBox();
  }
}

uploadFiles(titulo, descripcion, categoria, keywords, video, archivo, link, username,sampleImage) async{
  final StorageReference myPost = FirebaseStorage.instance.ref().child("Post Files");

  var timeKey = new DateTime.now();

  // logica aca si no hay imagenes, videos, archivos, etc
  if(sampleImage!=null){
    final StorageUploadTask uploadTask = myPost.child(timeKey.toString() + ".jpg").putFile(sampleImage); 

  var postUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

  var url = postUrl.toString();

  print("Post url = " + url);

  saveToDatabase(titulo, descripcion, categoria, keywords, video, archivo, link, username, url);
  }else{
    saveToDatabase(titulo, descripcion, categoria, keywords, null, archivo, link, username, null);
  }
  
}