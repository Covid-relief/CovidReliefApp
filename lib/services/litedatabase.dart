import 'package:CovidRelief/models/trace.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DBProvider {
 Database _database;

  Future initDB() async {

    if (_database!=null){
      return;
    }
    _database= await openDatabase('contacts.db', version: 1, onCreate: (Database db, int version){
       db.execute("CREATE TABLE traces(id INTEGER PRIMARY KEY, contact TEXT, time DATETIME);"); //Traces table
    });
    print('DB INITIALIZED');
  }

  addTrace(Trace trace) async {
    _database.insert('traces', trace.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,); //replace if traces already exists
  }
  
  Future<List<Trace>> getAllTraces() async {
    List<Map<String, dynamic>> traces= await _database.query('traces');
    
    return traces.map((map) => Trace.fromMap(map)).toList();
  }

}

