import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'students.dart';
import 'dart:async';

class DBHelper {
  static Database _db;
  static const String Id = 'controlnum';
  static const String NAME = 'name';
  static const String APP = 'app';
  static const String APPP = 'appP';
  static const String TELEF = 'telef';
  static const String CORREO = 'correo';
  static const String MATRICULA = 'matricula';
  static const String SEARCH = '1';
  static const String COMPARACION = 'comparacion';
  static const String TABLE = 'Students';
  static const String DB_NAME = 'students02.db';

  // CREACION DB (VERIFICACION)
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  // CREACION DATABASE
  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT, $APP TEXT, $APPP TEXT, $TELEF TEXT, $CORREO TEXT, $MATRICULA TEXT)");
  }

  // SELECT
  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [Id, NAME, APP, APPP, TELEF, CORREO, MATRICULA]);
    List<Student> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(Student.fromMap(maps[i]));
      }
    }
    return students;
  }

  // SELECT LIKE
  Future<List<Student>> getStudent(String matriculaBusqueda) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE WHERE $MATRICULA LIKE '%$matriculaBusqueda%'");
    List<Student> student = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        print(Student.fromMap(maps[i]).matricula);
        student.add(Student.fromMap(maps[i]));
      }
    }
    return student;
  }

  // SAVE O INSERT
  Future<bool> validateInsert(Student student) async {
    var dbClient = await db;
    var code = student.matricula;
    List<Map> maps = await dbClient
        .rawQuery("select $Id from $TABLE where $MATRICULA = $code");
    if (maps.length == 0) {
      return true;
    }else{
      return false;
    }
  }
  Future<Student> insert(Student student) async {
    var dbClient = await db;
      student.controlnum = await dbClient.insert(TABLE, student.toMap());
  }

  // DELETE
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

  // UPDATE
  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(),
        where: '$Id = ?', whereArgs: [student.controlnum]);
  }

  // CLOSE
  Future closedb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
