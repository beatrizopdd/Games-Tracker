import 'database_controller.dart';

import 'package:sqflite/sqflite.dart';
/*import '../controller/genre_controller.dart';
import '../controller/game_controller.dart';*/
import '../model/review.dart';

class ReviewController {
  static final String tableName = "review";
  static Database? db;

  /*CREATE TABLE review(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            game_id INTEGER NOT NULL,
            score REAL NOT NULL,
            description TEXT,
            date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES user(id),
            FOREIGN KEY(game_id) REFERENCES game(id) */

  static Future<Database?> get _db async {
    db ??= await DatabaseController.db;
    return db;
  }

  static Future<Review?> findReview(int user_id, int game_id) async {
    //bom para o filtro depois,
    String table = 'review';
    List<String> columns = [
      'id',
      'user_id',
      'game_id',
      'score',
      'description',
      'date'
    ];
    String where = 'user_id = ? AND game_id = ?';
    List<dynamic> whereArgs = [user_id, game_id];

    // Executando a consulta
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    // Verificando se a lista não está vazia antes de criar o review

    Review? review;
    if (result.isNotEmpty) {
      review = Review.fromMap(result.first);
    }

    // Imprimindo o review para verificar o mapeamento
    for (var i in result) {
      print(i);
    }

    if (review != null) {
      print(
          'ID: ${review.id}, USER_ID: ${review.user_id}, GAME_ID: ${review.game_id}, SCORE: ${review.score}, DESCRIPTION: ${review.date}');
    } else {
      print('Nenhum review encontrado na lista.');
    }

    return review;
  }


  static Future<int> insertReview(int user_id,int game_id,String description,double score,String date) async {
    var database = await _db;
        
    int id = await database!.insert(tableName,{'user_id' : user_id,'game_id':game_id,'description':description,'score': score,'date':date });

    return id;
  }

  static Future<int> deleteReviewbyId(int id) async {
    var database = db;
    int result =
        await database!.delete(tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> deleteReviewbyGame(int game_id) async {
    var database = db;
    int result =
        await database!.delete(tableName, where: "game_id = ?", whereArgs: [game_id]);
    return result;
  }

  static Future<int> deleteReviewbyUser(int user_id) async {
    var database = db;
    int result =
        await database!.delete(tableName, where: "user_id = ?", whereArgs: [user_id]);
    return result;
  }

  static Future<List<Review>> objetifyTableReviewbyUser(int? user_id) async {
    var database = await _db;
    List<Map<String, dynamic>> result = [];

    if (user_id == null) {
      result = await database!.query('review');
    }else {
      // Definindo os parâmetros para a consulta
      String table = 'review';
      List<String> columns = [
        'id',
        'user_id',
        'game_id',
        'score',
        'description',
        'date'
      ];
      String where = 'user_id LIKE ?';
      List<dynamic> whereArgs = [user_id];

      // Executando a consulta
      var database = await _db;
      result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs
    );
      
    }
    
    // Apenas para depuração
    print("\n" * 5);
    for (var row in result) {
      print(row);
    }
    print("\n" * 5);

    List<Review> reviews = []; // Inicializa a lista de reviews
    for (var game in result) {
      Review value = Review.fromMap(game);
      reviews.add(value);
    }

    for (var review in reviews) {
      print(review.id);
    }

    return reviews; // Retorna a lista de reviews
  }

  static Future<List<Review>> objetifyTableReviewbyGame(int? game_id) async {
    var database = await _db;
    List<Map<String, dynamic>> result = [];

    if (game_id == null) {
      result = await database!.query('review');
    }else {
      // Definindo os parâmetros para a consulta
      String table = 'review';
      List<String> columns = [
        'id',
        'user_id',
        'game_id',
        'score',
        'description',
        'date'
      ];
      String where = 'game_id LIKE ?';
      List<dynamic> whereArgs = [game_id];

      // Executando a consulta
      var database = await _db;
      result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs
    );
      
    }
    
    // Apenas para depuração
    print("\n" * 5);
    for (var row in result) {
      print(row);
    }
    print("\n" * 5);

    List<Review> reviews = []; // Inicializa a lista de reviews
    for (var game in result) {
      Review value = Review.fromMap(game);
      reviews.add(value);
    }

    for (var review in reviews) {
      print(review.id);
    }

    return reviews; // Retorna a lista de reviews
  }




  /*

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
}*/
}
