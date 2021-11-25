import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_flutter/data/model/register_data.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'register.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE register(
      id INTEGER PRIMARY KEY,
      name TEXT
    )
    ''');
  }

  Future<List<RegisterData>> getRegister() async {
    Database db = await instance.database;
    var registers = await db.query('register', orderBy: 'name');
    List<RegisterData> registerList = registers.isNotEmpty
        ? registers.map((e) => RegisterData.fromMap(e)).toList()
        : [];
    return registerList;
  }

  Future<int> add(RegisterData registerData) async {
    Database db = await instance.database;
    return await db.insert('register', registerData.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('register', where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(RegisterData registerData) async {
    Database db = await instance.database;
    return await db.update('register', registerData.toMap(),
        where: 'id=?', whereArgs: [registerData.id]);
  }
}
