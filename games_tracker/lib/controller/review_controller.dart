/* import 'database_controller.dart';

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
/*   static Future<Review?> findReview(String name) async{//bom para o filtro depois,
    String table = 'review';
    List<String> columns = ['id','name'];
    String where = 'name LIKE ?';
    List<dynamic> whereArgs = [name];

    // Executando a consulta
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    // Verificando se a lista não está vazia antes de criar o genero

    Review? genre;
    if (result.isNotEmpty) {
      genre = Review.fromMap(result.first);
    }

    // Imprimindo o genero para verificar o mapeamento
    for(var i in result){//result tem todas as instancias do genero
      print(i);
    }
    
    if (genre != null) {
      print(
          'ID: ${genre.id}, Genero: ${genre.name}');
      } else {
        print('Nenhum item desse gênero encontrado na lista.');
      }

    return genre;
  } */


  static Future<int> insertreview(int user_id,int game_id,String description,double score,String date) async {
    var database = await _db;
        
    int id = await database!.insert(tableName,{'user_id' : user_id,'game_id':game_id,'description':description,'score': score,'date':date });

    return id;
  }

  static getgames() async {
    var database = db;
    String sql = "SELECT * FROM $tableName";

    List games = await database!.rawQuery(sql);

    return games;
  }

  Future<int> updatreview(int user_id,int game_id,String description,double score,String date) async {//para o usuario atualizar a review
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