import 'database_controller.dart';

import 'package:sqflite/sqflite.dart';
import '../controller/genre_controller.dart';
import '../controller/game_genre_controller.dart';

import '../model/game.dart';
import '../model/genre.dart';



class GameController {
  static final String tableName = "game";
  static Database? db;

  static Future<Database?> get _db async {
    return db ??= await DatabaseController.db;
  }

  static Future<void> printaTableGame() async {
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query('game');
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

  static Future<int> insertGame(int user_id, String name, String description,
      String release_date, String genre) async {//List<String> - for para verificação 
    var database = await _db;

    int result = await database!
        .insert('game', {'user_id': user_id,'name': name, 'description': description, 'release_date': release_date});

    List<String> lista_generos = genre.split(',');

    for(String s in lista_generos){
      print("printando S $s");
      int res_gen = await GenreController.cadastraGenre(s);//vai ficar dentro do for
      print("resgen $res_gen");
      int res_gen_game = await Game_Genre_Controller.cadastraGame_Genre(result,res_gen);
      print("resgengame $res_gen_game");
    }

    //int res_gen = await GenreController.cadastraGenre(genre);//vai ficar dentro do for
    //if(result > 0 && res_gen >0){//sla
      //int res_gen_game = Game_Genre_Controller.cadastraGame_Genre(result,res_gen);//vai ficar dentro do for
      //res_gen_game vai retornar se conseguiu inserir ou não, -1 NÃO INSERIU, >0 INSERIU(caso precise);
    //}    
    //mandar id do game pra genre_game e o id do genre pra la também, o res_gen e o result geram os ids

    print(result);
    return result;
  }

  static Future<int> deleteGame(String name) async {
    var database = await _db;
    
    //Game? game;
    Game? aux_game_genre  = await findGame(name);
    
    
    /*int game_genre_result =*/await database!.delete('game_genre',where: "game_id = ?", whereArgs: [aux_game_genre!.id]);

    int result =
        await database.delete(tableName, where: "name = ?", whereArgs: [name]);


    return result;
  }

  static Future<Game?> findGame(String name) async {
    String table = 'game';
    List<String> columns = [
      'id',
      'user_id',
      'name',
      'release_date',
      'description'
    ];
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

    // Verificando se a lista não está vazia antes de criar o jogo

    Game? game;
    if (result.isNotEmpty) {
      game = Game.fromMap(result.first);
    }

    // Imprimindo o jogo para verificar o mapeamento

    if (game != null) {
      print(
          'ID: ${game.id}, User_ID: ${game.user_id} Name: ${game.name}, Release_Date: ${game.release_date}, Description: ${game.description}');
    } else {
      print('Nenhum game encontrado na lista.');
    }
    return game;
  }
  static Future<Game?> findGameID(int id) async {
    String table = 'game';
    List<String> columns = [
      'id',
      'user_id',
      'name',
      'release_date',
      'description'
    ];
    String where = 'id LIKE ?';
    List<dynamic> whereArgs = [id];

    // Executando a consulta
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    // Verificando se a lista não está vazia antes de criar o jogo

    Game? game;
    if (result.isNotEmpty) {
      game = Game.fromMap(result.first);
    }

    // Imprimindo o jogo para verificar o mapeamento

    if (game != null) {
      print(
          'ID: ${game.id}, User_ID: ${game.user_id} Name: ${game.name}, Release_Date: ${game.release_date}, Description: ${game.description}');
    } else {
      print('Nenhum game encontrado na lista.');
    }
    return game;
  }

  //cadastro
  static Future<int> cadastraGame(int user_id, String name, String description,
      String release_date, String genre) async {
    if (name == '' ||
        description == '' ||
        release_date == '' ||
        genre == '' ||
        user_id < 1) {
      return 0;
    }

    // Definindo os parâmetros para a consulta
    String table = 'game';
    List<String> columns = [
      'id',
      'user_id',
      'name',
      'description',
      'release_date'
    ];
    String where = 'name LIKE ?';
    List<dynamic> whereArgs = [name];
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

    //Realizar a mesma coisa que o Fred fez na área de register para a área de cadastro de jogo novo.
    if (result.isEmpty) {
      return insertGame(user_id, name, description, release_date, genre);
    } else {
      return -1;
    }
  }

  static Future<List<Game>> objetifyTableGame(int? user_id) async {
    var database = await _db;
    List<Map<String, dynamic>> result = [];

    if (user_id == null) {
      result = await database!.query('game');
    }else {
      // Definindo os parâmetros para a consulta
      String table = 'game';
      List<String> columns = [
        'id',
        'user_id',
        'name',
        'description',
        'release_date'
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

    List<Game> games = []; // Inicializa a lista de jogos
    for (var game in result) {
      Game value = Game.fromMap(game);
      games.add(value);
    }

    for (var game in games) {
      print(game.name);
    }

    return games; // Retorna a lista de jogos
  }
 
  //filtro data crescente e decrescente
  //filtro notas
  static Future<List<Game>> objetifyFiltroData(String release_date) async {
  /*  if (name == '' ||
        description == '' ||
        release_date == '' ||
        genre == '' ||
        user_id < 1) {
      return 0;
    } */

    // Definindo os parâmetros para a consulta
    String table = 'game';
    List<String> columns = [
      'id',
      'user_id',
      'name',
      'description',
      'release_date'
    ];
      String where = 'release_date LIKE ?';
      List<dynamic> whereArgs = ['%$release_date%'];
      String? groupBy;
      String? having;
      String? orderBy;//ordenação 
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
    //ESTOU COMENDO 

    List<Game> games = []; // Inicializa a lista de jogos
    for (var game in result) {
      Game value = Game.fromMap(game);
      games.add(value);
    }

    for (var game in games) {
      print(game.name);
    }

    return games;
  }


  //FAZER DEPOIS DO REVIEW
  static Future<List<Game>> filtronota(bool order) async {//????
  /*  if (name == '' ||
        description == '' ||
        release_date == '' ||
        genre == '' ||
        user_id < 1) {
      return 0;
    } */

    // Definindo os parâmetros para a consulta
    String table = 'game';
    List<String> columns = [
      'id',
      'user_id',
      'name',
      'description',
      'release_date'
    ];
      String where = 'name LIKE ?';
      List<dynamic>? whereArgs;
      String? groupBy;
      String? having;
      String? orderBy ;//ordenação 
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
    //ESTOU COMENDO 

    List<Game> games = []; // Inicializa a lista de jogos
    for (var game in result) {
      Game value = Game.fromMap(game);
      games.add(value);
    }

    for (var game in games) {
      print(game.name);
    }

    return games;
  }


  //dar um find depois do textfield e assim receber os campos do jogo e  botar nos campos o que estava antes  e passar para ca o que quer mudar
  Future<Game?> updategame(String name,String description,String release_date,int id) async {//para o usuario atualizar o jogo
    var database = await _db;
    Map<String, dynamic> updatedData = {
    'description': description,
    'release_date': release_date,
    'name': name
  };
    //int result =
        await database!.update('game',updatedData, where: "id = ?", whereArgs: [id]);
 
    Game? aux_game_genre  = await findGame(name);
    
    return (aux_game_genre);//cada campo no HUD vai mostrar cada campo de name,description e release_date na tela
  }


  static Future<List<Game>> objetifyFiltroGenero(String name) async {//name == nome do genero
  /*  if (name == '' ||
        description == '' ||
        release_date == '' ||
        genre == '' ||
        user_id < 1) {
      return 0;
    } */

    // Definindo os parâmetros para a consulta
    Genre? aux_game_genre  = await GenreController.findGenre(name);
    //teste
    String table = 'game_genre';
    List<String> columns = [
      'game_id',
      'genre_id',
    ];
      String where = 'genre_id LIKE ?';
      List<dynamic> whereArgs = [aux_game_genre!.id];
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
    print("sla");
    List<Game> games = [];
    for (var row in result) {
      var gameId = row['game_id'];
      Game? aux  =  await findGameID(gameId);
      games.add(aux!);
      print('Game ID: $gameId');
    }

    return games;
  }

  static Future<String?> findGenreListfromGame(Game jogo) async {
    /*

    // Executando a consulta em Game para descobrir o ID do Jogo
    
    List<Map<String, dynamic>> game_id = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );*/

    //Acesso ao Banco de Dados
    var database = await _db;

    //Declaração das variáveis de consulta
    String table;
    List<String> columns = [];
    String where;
    List<dynamic> whereArgs;

    //Setando parametros para consulta em Game_Genre para descobrir o ID do Genre
    table = 'game_genre';
    columns = ['genre_id'];
    where = 'game_id = ?';
    whereArgs = [jogo.id];

    //Executando a consulta em Game_Genre para descobrir o ID do Genre
    List<Map<String, dynamic>> genre_id_list = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    //Trocando parâmetros para consulta em Genre

    table = 'genre';
    columns = ['name'];
    where = 'id = ?';
    //whereArgs = [genre_id_list];

    String final_result = '';

    //{genre_id = 9}
    for (var row in genre_id_list) {
      var id = row['genre_id'];
      whereArgs = [id];
      List<Map<String, dynamic>> genre_name = await database.query(
        table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
      );
      print('genre_name = $genre_name');
      var name = genre_name.first['name'];
      if (final_result == '') {
        final_result = '$name';
      } else {
        final_result = '$final_result ,$name';
      }
      
    }

    print(final_result);

    return final_result;
    /*
    List<Map<String, dynamic>> result;

    await database.query(
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

    // Imprimindo o jogo para verificar o mapeamento

    if (genre != null) {
      print('ID: ${genre.id}, Name: ${genre.name}');
    } else {
      print('Nenhum genre encontrado na lista.');
    }
    return genre;*/
  }
}
