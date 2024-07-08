import 'package:flutter/material.dart';
import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/model/review.dart';

class GamePageV extends StatefulWidget {
  const GamePageV({super.key});
  @override
  State<GamePageV> createState() => _GamePageState();
}

class _GamePageState extends State<GamePageV> {

  late Game game;

  // Lista de reviews
  late List<Review> reviewList;

  @override
  Widget build(BuildContext context) {
    game = ModalRoute.of(context)!.settings.arguments as  Game;

    return Scaffold(
      // Nome do jogo
      appBar: AppBar(
        title: Text(
          game.name,
          style: const TextStyle(
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

          // Lançamento
          Row(
            children: [
              const Text(
                "LANÇAMENTO:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(game.release_date),
            ],
          ),

          // Média
          const Row(
            children: [
              const Text(
                "MÉDIA:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // INSERIR MÉDIA
              Text("4.5"),
              const Icon(Icons.star, size: 20, color: Colors.amber),
            ],
          ),

          // Descrição
          const Text(
            "DESCRIÇÃO:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(game.description),

          // Reviews
          Expanded(
            child: ListView.builder(
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(5),

                  // Gênero
                  leading: const Icon(Icons.person, size: 40),

                  // Nota
                  title: Row(
                    children: [
                      Text(
                        "${reviewList[index].score}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Icon(Icons.star, size: 20, color: Colors.amber),
                    ],
                  ),

                  // Descrição
                  subtitle: Text(reviewList[index].description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
