import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;
import 'task_controller.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/game.dart';

class DatabaseController {
  static final String tableName = "game";
  static final DatabaseController _DatabaseController =
      DatabaseController._internal();
  static Database? _db;

  factory DatabaseController() {
    return _DatabaseController;
  }

  DatabaseController._internal();

  Future<Database?> get db async {
    /*if (_db == null) {
      _db = initDb();
    }
    If é substituído pelo comando "??="
    */

    _db ??= await _initDb();

    return _db;
  }

  Future<int> insertgame(Game game) async {
    var database = await db;

    int id = await database!.insert(tableName, game.toMap());

    return id;
  }

  getgames() async {
    var database = await db;
    String sql = "SELECT * FROM $tableName";

    List games = await database!.rawQuery(sql);

    return games;
  }

  Future<int> updategame(Game game) async {
    var database = await db;

    int result = await database!.update(tableName, game.toMap(),
        where: "id = ?", whereArgs: [game.id!]);

    return result;
  }

  Future<int> deletegame(int id) async {
    var database = await db;

    int result =
        await database!.delete(tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}
