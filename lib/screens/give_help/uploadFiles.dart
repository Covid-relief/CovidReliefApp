import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:CovidRelief/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:CovidRelief/screens/give_help/postToDB.dart';
import 'package:video_player/video_player.dart';

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

VideoPlayerController videoUp (video){
  if (video!=null){
    //var videoPlayerControl = VideoPlayerController.file(video);
    return VideoPlayerController.file(video);
  }else{
    return VideoPlayerController.network('');
  }
}

uploadFiles(titulo, descripcion, categoria, keywords, video, archivo, link, username, sampleImage, estado) async{
  final StorageReference myPost = FirebaseStorage.instance.ref().child("Post Files");

  var timeKey = new DateTime.now();
  var img;
  var vid;
  var arc;

  // logica aca si hay imagenes, videos, archivos
   if(sampleImage!=null){
    final StorageUploadTask uploadImg = myPost.child(timeKey.toString() + "img.jpg").putFile(sampleImage); 
    var imgUrl = await (await uploadImg.onComplete).ref.getDownloadURL();
    img = imgUrl.toString();

    print("Image url = " + img);
  }

  if(video!=null){
    final StorageUploadTask uploadVid = myPost.child(timeKey.toString() + "vid.mp4").putFile(video, StorageMetadata(contentType: 'video/mp4'));
    var vidUrl = await (await uploadVid.onComplete).ref.getDownloadURL();
    vid = vidUrl.toString();

    print("Video url = " + vid);
  }

  if(archivo!=null){
    var completePath = archivo.toString();
    var fileName = (completePath.split('/').last).split('.').last;
    var ext =  fileName.substring(0, fileName.length-1);

    final StorageUploadTask uploadArc = myPost.child(timeKey.toString() + 'arc.' +ext).putFile(archivo);
    var arcUrl = await (await uploadArc.onComplete).ref.getDownloadURL();
    arc = arcUrl.toString();

    print("Archivo url = " + arc);
  }
  saveToDatabase(titulo, descripcion, categoria, keywords, vid, arc, link, username, img, estado);
  
}