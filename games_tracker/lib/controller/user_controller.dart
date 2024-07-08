import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'database_controller.dart';

import '../model/user.dart';

class UserController {
  static final String tableName = "user";
  static Database? db;

  static Future<Database?> get _db async {
    return db ??= await DatabaseController.db;
  }

  static Future<void> printaTableUser() async {
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query('user');
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

  static Future<int> insertUser(String nome, String email, String senha) async {
    var database = await _db;

    int result = await database!
        .insert('user', {'name': nome, 'email': email, 'password': senha});
    return result;
  }

  static Future<int> deleteUser(String nome) async {
    var database = await _db;
    return await database!.delete('user', where: 'name = ?', whereArgs: [nome]);
  }

  static Future<User?> findUser(String email, String senha) async {
    // Definindo os parâmetros para a consulta
    String table = 'user';
    List<String> columns = ['id', 'name', 'email', 'password'];
    String where = 'email LIKE ? AND password LIKE ?';
    List<dynamic> whereArgs = [email, senha];

    // Executando a consulta
    var database = await _db;
    List<Map<String, dynamic>> result = await database!.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
    );

    // Verificando se a lista não está vazia antes de criar o usuário

    User? user;
    if (result.isNotEmpty) {
      user = User.fromMap(result.first);
    }

    // Imprimindo o usuário para verificar o mapeamento

    if (user != null) {
      print(
          'ID: ${user.id}, Name: ${user.name}, Email: ${user.email}, Password: ${user.password}');
    } else {
      print('Nenhum usuário encontrado na lista.');
    }

    return user;
  }

  static Future<int> cadastraUser(
      String nome, String email, String senha) async {
    if (nome == '' || email == '' || senha == '') {
      return 0;
    }

    // Definindo os parâmetros para a consulta
    String table = 'user';
    List<String> columns = ['id', 'name', 'email', 'password'];
    String where = 'email LIKE ?';
    List<dynamic> whereArgs = [email];
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
      return insertUser(nome, email, senha);
    } else {
      return -1;
    }
  }
}
