import 'database_controller.dart';

import 'package:sqflite/sqflite.dart';
import '../controller/genre_controller.dart';
import '../controller/game_controller.dart';
import '../model/game_genre.dart';

class Game_Genre_Controller {
  static final String tableName = "game_genre";
  static Database? db;

  static Future<Database?> get _db async {

    db ??= await DatabaseController.db;

    return db;
  }
  static Future<void> printaTableGame_Genre() async {
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query('game_genre');
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    for (var row in result) {
      print(row);
    }
    print("\n");
    print("\n");
    print("\n");
    print("\n");
    print("\n");
  }
  

  static Future<int> insert_game_genre(int genre_id,int game_id) async {
    var database = await _db;
    int id = await database!.insert(tableName, {'genre_id': genre_id,'game_id': game_id});

    return id;
  }
  

  
  //ajeitar para problemas de delete
  Future<int> deletegame(int game_id,int genre_id) async {
    var database = db;

    int result =
        await database!.delete(tableName, where: "game_id = ? AND genre_id = ?", whereArgs: [game_id,genre_id]);

    return result;
  }
}