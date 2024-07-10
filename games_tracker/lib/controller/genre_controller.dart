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

    // Imprimindo o genero para verificar o mapeamento
    //for (var i in result) {
      //result tem todas as instancias do genero
     //print(i);
    //}

    if (genre != null) {
      print('ID: ${genre.id}, Genero: ${genre.name}');
    } else {
      print('Nenhum item desse gênero encontrado na lista.');
    }

    return genre;
  }

  /*static Future<int> cadastraGenre(
      String name) async {
    if (name == '') {
      return 0;
    }

    // Definindo os parâmetros para a consulta
    String table = 'genre';
    List<String> columns = ['id', 'name'];
    String where = 'name LIKE ?';
    List<dynamic> whereArgs = ['%$name%'];
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
      return insertGenre(name);
    } else {
      return -1;
    }
  }

    //Nosso
    static Future<int> deleteGenre(String name) async {
    var database = await _db;

    int result =
        await database!.delete(tableName, where: "name = ?", whereArgs: [name]);

    print(result);
    return result;
  }*/

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

    print('Query result: $result');

    if (result.isEmpty) {
      return insertGenre(name);
    } else {
      print("Genre Já Existe");
      int id = result[0]['id'];
      return id;
    }
    
  }


static Future<String> updategenre(String name,int game_id) async {//para o usuario atualizar o jogo
    var database = await _db;//Aventura,Ação,RPG

  Set<String> lista_generos = name.split(',').toSet();//Aventura,RPG
  
    for (String s in lista_generos) {
      print("printando S $s");
      int res_gen =
          await GenreController.cadastraGenre(s.trim()); //vai ficar dentro do for
      print("resgen $res_gen");
      if(res_gen > 0){
        int res_gen_game =
          await Game_Genre_Controller.cadastraGame_Genre(game_id, res_gen);
          print("resgengame $res_gen_game");
        }
    }
    print(lista_generos.toString());
    return (lista_generos.toString());//cada campo no HUD vai mostrar cada campo de name,description e release_date na tela
  } 



}
