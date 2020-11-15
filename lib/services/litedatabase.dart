import 'package:CovidRelief/models/trace.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DBProvider {
 Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future initDB() async {
    print("initializing DB");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "contacts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE traces(id INTEGER PRIMARY KEY, contact TEXT, time DATETIME);"); //Traces table
    });
  }

  addTrace(Trace trace, String uid) async {
    var queryResult = await _database.rawQuery('SELECT * FROM traces WHERE contact=?',[uid]);
    if (queryResult.isNotEmpty){
      await _database.delete('traces', where: "contact = ?", whereArgs: [uid]);
      _database.insert('traces', trace.toMap());
    }
    else {
      _database.insert('traces', trace.toMap());
    }
  }
  
  Future<List<Trace>> getAllTraces() async {
    List<Map<String, dynamic>> traces= await _database.query('traces');
    
    return traces.map((map) => Trace.fromMap(map));
  }

}

