import 'database_controller.dart';
import 'package:sqflite/sqflite.dart';
import '../model/genre.dart';

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


    int result = await database!
        .insert('genre', {'name': genre});
        
    return result;
  }

  static Future<Genre?> findGenre(String name) async{//bom para o filtro depois,
    String table = 'genre';
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

    Genre? genre;
    if (result.isNotEmpty) {
      genre = Genre.fromMap(result.first);
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
  }

  static Future<int> cadastraGenre(
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
  }
}

