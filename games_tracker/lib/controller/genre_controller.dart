import 'database_controller.dart';
import 'package:sqflite/sqflite.dart';

import '../model/genre.dart';

class GameController {
  static final String tableName = "game";
  static Database? db;

  static Future<Database?> get _db async {
    return db ??= await DatabaseController.db;
  }

  static Future<int> insertGenre(String genre) async {
    var database = await _db;

    int result = await database!
        .insert('genre', {'name': genre});
        
    return result;
  }


  Future<int> deletegame(int id) async {
    var database = db;

    int result =
        await database!.delete(tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}
