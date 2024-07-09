/*import 'database_controller.dart';

import 'package:sqflite/sqflite.dart';
import '../controller/genre_controller.dart';
import '../controller/game_controller.dart';
import '../model/review.dart';

class GameController {
  static final String tableName = "review";
  static Database? db;


  static Future<Database?> get _db async {
    /*if (_db == null) {
      _db = initDb();
    }
    If é substituído pelo comando "??="
    */

    db ??= await DatabaseController.db;

    return db;
  }

  Future<int> insertgame(int user_id,int game_id,String description,double score,String date) async {
    var database = db;

    int id = await database!.insert(tableName,);


    return id;
  }




  static getgames() async {
    var database = db;
    String sql = "SELECT * FROM $tableName";

    List games = await database!.rawQuery(sql);

    return games;
  }

  Future<int> updategame(Review review) async {
    var database = db;

    int result = await database!.update(tableName, review.toMap(),
        where: "id = ?", whereArgs: [review.id!]);

    return result;
  }

  Future<int> deletegame(int id) async {
    var database = db;

    int result =
        await database!.delete(tableName, where: "id = ?", whereArgs: [id]);

    return result;
  }
}
*/