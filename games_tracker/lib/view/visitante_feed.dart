import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/controller/review_controller.dart';
import 'package:games_tracker/model/game.dart';

class FeedVisitante extends StatefulWidget {
  const FeedVisitante({super.key});
  @override
  State<FeedVisitante> createState() => _FeedVisitanteState();
}

class _FeedVisitanteState extends State<FeedVisitante> {
  Future<List<Map<String, dynamic>>> getGames() async {
    List<Game> gameList = [];
    List<Map<String, dynamic>> gameListWithAverages = [];

    gameList = await GameController.objetifyTableGame(null);
    for (Game game in gameList) {
      String? avg = await ReviewController.mediaByGame(game.id);
      gameListWithAverages.add({'game': game, 'average': avg});
    }

    return gameListWithAverages;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cabeçalho
      appBar: AppBar(
        // Título do feed
        title: const Text(
          "Games Tracker",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Aparência
        foregroundColor: Colors.white,
        centerTitle: true,
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
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Lista de Jogos
          FutureBuilder(
            future: getGames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data == null) {
                return const Center(
                    child: Text("Lista de jogos retornando null"));

                // Se tudo deu certo:
              } else {
                List<Map<String, dynamic>>? gameListWithAverages =
                    snapshot.data;

                // Lista vazia
                if (gameListWithAverages!.isEmpty) {
                  return const Center(child: Icon(Icons.videogame_asset_off));

                  // Lista com elementos
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: gameListWithAverages.length,
                      itemBuilder: (context, index) {
                        Game game = gameListWithAverages[index]['game'];
                        String average = gameListWithAverages[index]['average'];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(5),
                          leading: const Icon(Icons.videogame_asset, size: 40),

                          // Informações
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Nome
                              Expanded(child: Text(game.name)),

                              // Média
                              Row(
                                children: [
                                  Text(
                                    average,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Entrar na página
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              "/game_page_visitante",
                              arguments: [
                                null,
                                game,
                                gameListWithAverages[index]['average']
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
