import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ArtHub/common/model.dart';

class DataBaseFunctions {
  static const _databaseName = 'Cart.db';
  static const _databaseVersion = 1;
  DataBaseFunctions._();
  static final databaseinstance = DataBaseFunctions._();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory =
        await getApplicationDocumentsDirectory(); // to get the location
    String dbPath =
        join(dataDirectory.path, _databaseName); // to get the database path
    return await openDatabase(dbPath,
        version: _databaseVersion,
        onCreate: _onCreateDB); // create the connection to the database
  }

  _onCreateDB(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE ${ParsedDataProduct.tableName}(
      ${ParsedDataProduct.colID} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ParsedDataProduct.colArtistName} TEXT NOT NULL,
      ${ParsedDataProduct.colProductName} TEXT NOT NULL,
      ${ParsedDataProduct.colCost} INTEGER,
      ${ParsedDataProduct.colType} TEXT NOT NULL,
      ${ParsedDataProduct.colAvatar} TEXT NOT NULL,
      ${ParsedDataProduct.colDesc} TEXT NOT NULL,
      ${ParsedDataProduct.colDescription} TEXT NOT NULL,
      ${ParsedDataProduct.colWeight} INTEGER,
      ${ParsedDataProduct.colDimension} TEXT NOT NULL,
      ${ParsedDataProduct.colMaterials} TEXT NOT NULL
      )
    
    ''');
  }

  Future<int> insertitem(ParsedDataProduct data) async {
    Database db = await database;
    return await db.insert(ParsedDataProduct.tableName, data.toMap());
  }

  Future<int> deleteitem(int id) async {
    Database db = await database;
    return await db.delete(ParsedDataProduct.tableName,
        where: '${ParsedDataProduct.colID}=?', whereArgs: [id]);
  }

  Future<List<ParsedDataProduct>> fetchdata() async {
    Database db = await database;
    List<Map> cartlist = await db.query(ParsedDataProduct.tableName);
    return cartlist.length == 0
        ? []
        : cartlist.map((e) => ParsedDataProduct.fromMap(e)).toList();
  }
}
