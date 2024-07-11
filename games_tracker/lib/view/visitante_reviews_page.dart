import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/controller/user_controller.dart';
import 'package:games_tracker/controller/review_controller.dart';
import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/review.dart';

class ReviewPageVisitante extends StatefulWidget {
  const ReviewPageVisitante({super.key});
  @override
  State<ReviewPageVisitante> createState() => _ReviewPageVisitanteState();
}

class _ReviewPageVisitanteState extends State<ReviewPageVisitante> {
  late List<User> reviewAuthor = [];
  late List<Game> reviewGame = [];
  late int game_id;

  Future<List<Review>> getReviews() async {
    List<Review> reviewList = [];

    reviewList = await ReviewController.objetifyTableReviewbyGame(game_id);

    for (Review review in reviewList) {
      User? author = await UserController.findUserByID(review.user_id);
      reviewAuthor.add(author!);
      Game? game = await GameController.findGameByID(review.game_id);
      reviewGame.add(game!);
    }

    return reviewList;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    game_id = args[1] as int;

    return Scaffold(
      // Nome do jogo
      appBar: AppBar(
        title: const Text(
          "Reviews",
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

          // Reviews
          FutureBuilder(
            future: getReviews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data == null) {
                return const Center(
                    child: Text("Lista de reviews retornando null"));

                // Se tudo ser certo:
              } else {
                List<Review>? reviewList = snapshot.data;
                if (reviewList!.isEmpty) {
                  return const Center(child: Icon(Icons.block));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: reviewList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // Nota da review
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${reviewList[index].score}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Icon(Icons.star,
                                  size: 25, color: Colors.amber),
                            ],
                          ),

                          // Autor da review
                          title: Text(
                            reviewAuthor[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Jogo da review
                          trailing: Text(
                            reviewGame[index].name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          // Descrição
                          subtitle: Text(reviewList[index].description),
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
