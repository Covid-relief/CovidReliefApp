import 'package:CovidRelief/models/trace.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Suspensions.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _createTables);
  }

  void _createTables(Database db, int version) async {
    await db.execute("CREATE TABLE traces ("
        "id integer primary key AUTOINCREMENT,"
        "contact TEXT,"
        "time DATETIME"
        ")");
  }

  addTrace(Trace trace) async {
    //replace if traces already exists
    final db = _database;
    var raw = await db.insert(
      "traces",
      trace.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  getAllTraces() async {
   final db = _database;
   var response = await db.query("traces");
   List<Trace> list =response.isNotEmpty ? response.map((c) => Trace.fromMap(c)).toList() : [];
   return list;
 }

 deleteAllTraces() async {
   final db = _database;
   db.delete("traces");
 }

 }

