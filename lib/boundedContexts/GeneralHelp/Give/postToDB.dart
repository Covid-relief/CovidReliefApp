import 'package:CovidRelief/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:CovidRelief/boundedContexts/home/home.dart';

/**
 * Aqui recibimos los files para enviarlos a la realtime database
 */

saveToDatabase(titulo, descripcion, categoria, keywords, video, archivo, link,
    username, img, estado) {
  var dbTimeKey = new DateTime.now();
  var formatDate = new DateFormat('d MMM yyyy');
  var formatTime = new DateFormat.jm();
  var formatDay = new DateFormat('EEEE');

  String date = formatDate.format(dbTimeKey);
  String time = formatTime.format(dbTimeKey);
  String day = formatDay.format(dbTimeKey);

  switch (day) {
    case "Monday":
      {
        day = "Lunes";
      }
      break;
    case "Tuesday":
      {
        day = "Martes";
      }
      break;
    case "Wednesday":
      {
        day = "Miércoles";
      }
      break;
    case "Thursday":
      {
        day = "Jueves";
      }
      break;
    case "Friday":
      {
        day = "Viernes";
      }
      break;
    case "Saturday":
      {
        day = "Sábado";
      }
      break;
    case "Sunday":
      {
        day = "Domingo";
      }
      break;
  }

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  var data = {
    "Titulo": titulo,
    "Descripcion": descripcion,
    "Keywords": keywords,
    "Video": video,
    "Archivo": archivo,
    "Link": link,
    "username": username,
    "Imagen": img,
    "Fecha": date,
    "Hora": time,
    "Estado": estado,
    "Dia": day
  };
  ref.child(categoria).push().set(data);
}
