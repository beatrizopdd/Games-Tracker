/*import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;
import 'database_controller.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/game_genre.dart';

class GameController {
  static final String tableName = "game_genre";
  static Database? db;

  Future<Database?> get _db async {
    /*if (_db == null) {
      _db = initDb();
    }
    If é substituído pelo comando "??="
    */

    db ??= await DatabaseController.db;

    return db;
  }

  Future<int> insertgame(Game_Genre game_genre) async {
    var database = db;

    int id = await database!.insert(tableName, game_genre.toMap());

    return id;
  }

  getgames() async {
    var database = db;
    String sql = "SELECT * FROM $tableName";

    List games = await database!.rawQuery(sql);

    return games;
  }

  // Future<int> updategame(Game_Genre game_genre) async {
  //var database = db;

  //int result = await database!.update(tableName, game_genre.toMap(),
  //where: "id = ?", whereArgs: [game_genre.id!]);

  //return result;
  // }

  Future<int> deletegame(int id) async {
    var database = db;

    int result =
        await database!.delete(tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}*/