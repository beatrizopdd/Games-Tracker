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
  

  static Future<int> insert_game_genre(int game_id,int genre_id) async {
    var database = await _db;
    int id = await database!.insert(tableName, {'game_id': game_id,'genre_id': genre_id});

    return id;
  }
  
  //ajeitar para problemas de delete
  Future<int> delete_game_genre(int game_id,int genre_id) async {
    var database = db;

    int result =
        await database!.delete(tableName, where: "game_id = ? AND genre_id = ?", whereArgs: [game_id,genre_id]);

    return result;
  }


  static Future<int> cadastraGame_Genre(
    int game_id,int genre_id) async {
  /*  if (genre_id == '') {
      return 0;
    } */

    // Definindo os parâmetros para a consulta
    String table = 'game_genre';
    List<String> columns = ['game_id', 'genre_id'];
    String where = 'game_id LIKE ? and genre_id LIKE ?' ;
    List<dynamic> whereArgs = [game_id,genre_id];
    String? groupBy;
    String? having;
    String? orderBy;
    int? limit;
    int? offset;

    // Executando a consulta
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    if (result.isEmpty) {
      return insert_game_genre(game_id,genre_id);//tem que checar os dois pq pode ter 1 jogo com N gêneros
    } else {
      return -1;
    }
  }
}