import 'database_controller.dart';
import 'package:sqflite/sqflite.dart';
import '../model/genre.dart';
import 'game_genre_controller.dart';

class GenreController {
  static final String tableName = "genre";
  static Database? db;

  static Future<Database?> get _db async {
    return db ??= await DatabaseController.db;
  }

  static Future<void> printaTableGenre() async {
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query('genre');
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

  static Future<int> insertGenre(String genre) async {
    var database = await _db;

    int result = await database!.insert('genre', {'name': genre});

    return result;
  }

  static Future<Genre?> findGenre(String name) async {
    //bom para o filtro depois,
    String table = 'genre';
    List<String> columns = ['id', 'name'];
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

    Genre? genre;
    if (result.isNotEmpty) {
      genre = Genre.fromMap(result.first);
    }

    return genre;
  }


  static Future<int> cadastraGenre(String name) async {
    //teste
    if (name == '' || name == ' ') {
      return 0;
    }

    var database = await _db;
    if (database == null) {
      return -1;
    }

    // Verificação direta pelo nome exato
    List<Map<String, dynamic>> result = await database.query(
      'genre',
      columns: ['id', 'name'],
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],//'%name%
    );


    if (result.isEmpty) {
      return insertGenre(name);
    } else {
      int id = result[0]['id'];
      return id;
    }
    
  }
  static Future<int> deleteGenre(int game_id) async {
    var database = await _db;

    //Game? game;
    int game_genre_result = await database!.delete('game_genre',
        where: "game_id = ?", whereArgs: [game_id]);
    return game_genre_result;
  }


static Future<String> updateGenre(String name,int game_id) async {//para o usuario atualizar o jogo
   //Aventura,Ação,RPG,Aventuraaaa
    
    Set<String> lista_generos = name.split(',').toSet();

    await deleteGenre(game_id);
    
    for (String s in lista_generos) {
      int res_gen =
          await GenreController.cadastraGenre(s.trim()); //vai ficar dentro do for
      if(res_gen > 0){
          await Game_Genre_Controller.cadastraGame_Genre(game_id, res_gen);
        }
    }
    return (lista_generos.toString());//cada campo no HUD vai mostrar cada campo de name,description e release_date na tela
  } 



}
