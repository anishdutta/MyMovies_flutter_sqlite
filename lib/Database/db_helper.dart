import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'planmealcustinvoiceHD';
  static final columnId = '_id';
  static final moviename = 'moviename';
  static final director = 'director';
  static final imgstring = 'imgstring';


  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $moviename TEXT,
          $director TEXT,
          $imgstring TEXT
          
          )
          ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return  Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  delete(int id) async {
    Database? db = await instance.database;
    return await db!.rawQuery("DELETE FROM $table WHERE $columnId=$id");
  }

  deleteTable() async {
    Database? db = await instance.database;
    return await db!.rawQuery('DROP TABLE $table');
  }
}