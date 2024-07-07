import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class DatabaseService {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _inicialize();
    return _database;
  }

  Future<String> get fullPath async {
    const name = 'banco.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _inicialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
      singleInstance: true,
    );
    return database;
  }
  
  Future<void> printAllTables() async {
  final db = await database;
  if (db != null) {
    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';"
    );
    tables.forEach((table) {
      print('Table: ${table['name']}');
    });
  } else {
    print('Database is not initialized.');
  }
}
  
  Future<void> createDatabase(Database database, int version) async {
  await database.execute("""
    CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL,
      password VARCHAR NOT NULL
    );
  """);

  await database.execute("""
    CREATE TABLE genre(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL
    );
  """);

  await database.execute("""
    CREATE TABLE game(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      name VARCHAR NOT NULL UNIQUE,
      description TEXT NOT NULL,
      release_date VARCHAR NOT NULL,
      FOREIGN KEY(user_id) REFERENCES user(id)
    );
  """);

  await database.execute("""
    CREATE TABLE game_genre(
      game_id INTEGER NOT NULL,
      genre_id INTEGER NOT NULL,
      FOREIGN KEY(game_id) REFERENCES game(id),
      FOREIGN KEY(genre_id) REFERENCES genre(id)
    );
  """);

  await database.execute("""
    CREATE TABLE review(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      game_id INTEGER NOT NULL,
      score REAL NOT NULL,
      description TEXT,
      date VARCHAR NOT NULL,
      FOREIGN KEY(user_id) REFERENCES user(id),
      FOREIGN KEY(game_id) REFERENCES game(id)
    );
  """);

  // Inserções iniciais de dados
  await database.execute("""
    INSERT INTO user(name, email, password) VALUES('Teste 1', 'teste1@teste', '123456');
    INSERT INTO user(name, email, password) VALUES('Teste 2', 'teste2@teste', '123456');
    INSERT INTO user(name, email, password) VALUES('Teste 3', 'teste3@teste', '123456');
    INSERT INTO user(name, email, password) VALUES('Teste 4', 'teste4@teste', '123456');
    INSERT INTO user(name, email, password) VALUES('Teste 5', 'teste5@teste', '123456');

    INSERT INTO genre(name) VALUES('Aventura');
    INSERT INTO genre(name) VALUES('Ação');
    INSERT INTO genre(name) VALUES('RPG');
    INSERT INTO genre(name) VALUES('Plataforma');
    INSERT INTO genre(name) VALUES('Metroidvania');
    INSERT INTO genre(name) VALUES('Rogue Lite');
    INSERT INTO genre(name) VALUES('Survival Horror');
    INSERT INTO genre(name) VALUES('Mundo Aberto');

    INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'God of War', 'O jogo começa após a morte da segunda esposa de Kratos e mãe de Atreus, Faye. Seu último desejo era que suas cinzas fossem espalhadas no pico mais alto dos nove reinos nórdicos. Antes de iniciar sua jornada, Kratos é confrontado por um homem misterioso com poderes divinos.', '2018-04-18');
    INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'Resident Evil 4', 'Resident Evil 4 é um jogo de terror e sobrevivência no qual os jogadores terão que enfrentar situações extremas de medo. Apesar dos vários elementos de terror, o jogo é equilibrado com muita ação e uma experiência de jogo bastante variada.', '2023-03-24');
    INSERT INTO game(user_id, name, description, release_date) VALUES(2, 'Persona 5', 'Transferido para a Academia Shujin, em Tóquio, Ren Amamiya está prestes a entrar no segundo ano do colegial. Após um certo incidente, sua Persona desperta, e junto com seus amigos eles formam os Ladrões-Fantasma de Corações, para roubar a fonte dos desejos deturpados dos adultos e assim reformar seus corações.', '2017-04-17');
    INSERT INTO game(user_id, name, description, release_date) VALUES(3, 'Horizon Zero Dawn', 'Horizon Zero Dawn é um RPG eletrônico de ação em que os jogadores controlam a protagonista Aloy, uma caçadora e arqueira, em um cenário futurista, um mundo aberto pós-apocalíptico dominado por criaturas mecanizadas como robôs dinossauros.', '2017-02-28');

    INSERT INTO game_genre(game_id, genre_id) VALUES(1, 1);
    INSERT INTO game_genre(game_id, genre_id) VALUES(2, 7);
    INSERT INTO game_genre(game_id, genre_id) VALUES(3, 3);
    INSERT INTO game_genre(game_id, genre_id) VALUES(4, 2);
    INSERT INTO game_genre(game_id, genre_id) VALUES(4, 3);
    INSERT INTO game_genre(game_id, genre_id) VALUES(4, 8);

    INSERT INTO review(user_id, game_id, score, description, date) VALUES(1, 1, 9.5, 'Teste', '2024-06-20');
    INSERT INTO review(user_id, game_id, score, description, date) VALUES(2, 1, 9.0, 'Teste', '2024-06-20');
    INSERT INTO review(user_id, game_id, score, description, date) VALUES(3, 1, 8.5, 'Teste', '2024-06-20');
    INSERT INTO review(user_id, game_id, score, description, date) VALUES(4, 1, 9.6, 'Teste', '2024-06-20');
  """);
}

}



