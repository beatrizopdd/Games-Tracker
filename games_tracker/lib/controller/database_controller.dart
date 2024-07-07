import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

class DatabaseController {
  static final String tableName = "task";
  static final DatabaseController _DatabaseController = DatabaseController._internal();
  static Database? _db;

  factory DatabaseController() {
    return _DatabaseController;
  }

  DatabaseController._internal();

  static Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  static Future<Database?> _initDb() async {
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "databases", "task.db");
    print("Database Path: $path");

    Database? db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Criação das tabelas
        await db.execute('''
          CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE genre(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE game(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name VARCHAR NOT NULL UNIQUE,
            description TEXT NOT NULL,
            release_date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES user(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE game_genre(
            game_id INTEGER NOT NULL,
            genre_id INTEGER NOT NULL,
            FOREIGN KEY(game_id) REFERENCES game(id),
            FOREIGN KEY(genre_id) REFERENCES genre(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE review(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            game_id INTEGER NOT NULL,
            score REAL NOT NULL,
            description TEXT,
            date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES user(id),
            FOREIGN KEY(game_id) REFERENCES game(id)
          )
        ''');

        // Inserção de dados de exemplo
        await db.insert('user', {'name': 'Teste 1', 'email': 'teste1@teste', 'password': '123456'});
        await db.insert('user', {'name': 'Teste 2', 'email': 'teste2@teste', 'password': '123456'});
        await db.insert('user', {'name': 'Teste 3', 'email': 'teste3@teste', 'password': '123456'});
        await db.insert('user', {'name': 'Teste 4', 'email': 'teste4@teste', 'password': '123456'});
        await db.insert('user', {'name': 'Teste 5', 'email': 'teste5@teste', 'password': '123456'});

        await db.insert('genre', {'name': 'Aventura'});
        await db.insert('genre', {'name': 'Ação'});
        await db.insert('genre', {'name': 'RPG'});
        await db.insert('genre', {'name': 'Plataforma'});
        await db.insert('genre', {'name': 'Metroidvania'});
        await db.insert('genre', {'name': 'Rogue Lite'});
        await db.insert('genre', {'name': 'Survival Horror'});
        await db.insert('genre', {'name': 'Mundo Aberto'});

        await db.insert('game', {'user_id': 1, 'name': 'God of War', 'description': 'O jogo começa após a morte da segunda esposa de Kratos e mãe de Atreus, Faye. Seu último desejo era que suas cinzas fossem espalhadas no pico mais alto dos nove reinos nórdicos. Antes de iniciar sua jornada, Kratos é confrontado por um homem misterioso com poderes divinos.', 'release_date': '2018-04-18'});
        await db.insert('game', {'user_id': 1, 'name': 'Resident Evil 4', 'description': 'Resident Evil 4 é um jogo de terror e sobrevivência no qual os jogadores terão que enfrentar situações extremas de medo. Apesar dos vários elementos de terror, o jogo é equilibrado com muita ação e uma experiência de jogo bastante variada.', 'release_date': '2023-03-24'});
        await db.insert('game', {'user_id': 2, 'name': 'Persona 5', 'description': 'Transferido para a Academia Shujin, em Tóquio, Ren Amamiya está prestes a entrar no segundo ano do colegial. Após um certo incidente, sua Persona desperta, e junto com seus amigos eles formam os Ladrões-Fantasma de Corações, para roubar a fonte dos desejos deturpados dos adultos e assim reformar seus corações.', 'release_date': '2017-04-17'});
        await db.insert('game', {'user_id': 3, 'name': 'Horizon Zero Dawn', 'description': 'Horizon Zero Dawn é um RPG eletrônico de ação em que os jogadores controlam a protagonista Aloy, uma caçadora e arqueira, em um cenário futurista, um mundo aberto pós-apocalíptico dominado por criaturas mecanizadas como robôs dinossauros.', 'release_date': '2017-02-28'});

        await db.insert('game_genre', {'game_id': 1, 'genre_id': 1});
        await db.insert('game_genre', {'game_id': 2, 'genre_id': 7});
        await db.insert('game_genre', {'game_id': 3, 'genre_id': 3});
        await db.insert('game_genre', {'game_id': 4, 'genre_id': 2});
        await db.insert('game_genre', {'game_id': 4, 'genre_id': 3});
        await db.insert('game_genre', {'game_id': 4, 'genre_id': 8});

        await db.insert('review', {'user_id': 1, 'game_id': 1, 'score': 9.5, 'description': 'Teste', 'date': '2024-06-20'});
        await db.insert('review', {'user_id': 2, 'game_id': 1, 'score': 9.0, 'description': 'Teste', 'date': '2024-06-20'});
        await db.insert('review', {'user_id': 3, 'game_id': 1, 'score': 8.5, 'description': 'Teste', 'date': '2024-06-20'});
        await db.insert('review', {'user_id': 4, 'game_id': 1, 'score': 9.6, 'description': 'Teste', 'date': '2024-06-20'});
      }
    );

    return db;
  }

  // Função para imprimir o conteúdo da tabela no terminal
  static Future<void> printTable(String tableName) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient!.query(tableName);

    result.forEach((row) {
      print(row);
    });
  }
}

void main() async {
  await DatabaseController.db; // Certifique-se de que o banco de dados está inicializado

  // Imprima o conteúdo da tabela 'user'
  await DatabaseController.printTable('user');

  // Imprima o conteúdo de outras tabelas conforme necessário
  await DatabaseController.printTable('genre');
  await DatabaseController.printTable('game');
  await DatabaseController.printTable('game_genre');
  await DatabaseController.printTable('review');
}
