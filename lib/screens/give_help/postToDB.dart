import 'package:CovidRelief/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:CovidRelief/screens/home/home.dart';

/**
 * Aqui recibimos los files para enviarlos a la realtime database
 */

saveToDatabase(titulo, descripcion, categoria, keywords, video, archivo, link, username, img){
  var dbTimeKey = new DateTime.now();
  var formatDate = new DateFormat('MMM d, yyyy');
  var formatTime = new DateFormat('EEEE, hh:mm aaa');

  String date = formatDate.format(dbTimeKey);
  String time = formatTime.format(dbTimeKey);

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data = {
    "Titulo":titulo,
    "Descripcion":descripcion,
    "Keywords":keywords, 
    "Video":video, 
    "Archivo":archivo, 
    "Link":link, 
    "username":username, 
    "Imagen":img,
    "Fecha":date,
    "Hora":time
  };
  ref.child(categoria).push().set(data);
}