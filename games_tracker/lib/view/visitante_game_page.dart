import 'package:flutter/material.dart';
import 'package:games_tracker/controller/review_controller.dart';
import 'package:games_tracker/controller/user_controller.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

class GamePageVisitante extends StatefulWidget {
  const GamePageVisitante({super.key});
  @override
  State<GamePageVisitante> createState() => _GamePageVisitanteState();
}

class _GamePageVisitanteState extends State<GamePageVisitante> {
  late User gameAuthor;
  late Game game;
  late String avg;

  // Isso garante que o jogo esteja sempre atualizado
  Future<Game> updateGameData() async {
    game = (await GameController.findGameByID(game.id))!;
    avg = (await ReviewController.mediaByGame(game.id))!;
    gameAuthor = (await UserController.findUserByID(game.user_id))!;

    return game;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    game = args[1] as Game;
    avg = args[2] as String;

    return Scaffold(
      appBar: AppBar(
        // Aparência
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // Corpo
      body: FutureBuilder(
        future: updateGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Nome do jogo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Espaço
                  const SizedBox(height: 15),

                  // Usuário que adicionou o jogo
                  Row(
                    children: [
                      const Text(
                        "ADICIONADO POR ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        gameAuthor.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Espaço
                  const SizedBox(height: 10),

                  // Lançamento
                  Row(
                    children: [
                      const Text(
                        "LANÇADO EM ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        game.release_date,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Espaço
                  const SizedBox(height: 10),

                  // Média
                  Row(
                    children: [
                      const Text(
                        "MÉDIA: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        avg,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.star, size: 20, color: Colors.amber),
                    ],
                  ),

                  // Espaço
                  const SizedBox(height: 10),

                  // Descrição
                  const Text(
                    "DESCRIÇÃO:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                  // Espaço
                  const SizedBox(height: 5),

                  Text(
                    game.description,
                    style: const TextStyle(fontSize: 17),
                  ),

                  // Ver reviews
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "/reviews_page_visitante",
                              arguments: [null, game.id],
                            );
                          },
                          child: const Text("Ver reviews"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
