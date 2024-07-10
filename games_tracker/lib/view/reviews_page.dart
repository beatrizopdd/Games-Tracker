import 'package:flutter/material.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/model/review.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late User user;
  late int game_id;

  // Para a atualização da review
  late double _scoreController;
  TextEditingController _descriptionController = TextEditingController();

  // Lista de reviews
  // pra diferenciar se vem do feed (Minhas reviews recentes) ou do jogo (Ver reviewes)
  // ver se game_id == 0
  Future<List<Review>> getReviews() async {
    List<Review> reviewList = [];
    /*
    switch (op) {
      case 0:
        reviewList = await GameController.objetifyTableGame(user.id);
        break;
      default:
        break;
    }*/
    return reviewList;
  }

  // Atualizar review
  void updateReview(Review review) {
    // PROCEDIMENTO PRA ATUALIZAR REVIEW
  }

  // Deletar review
  void deleteReview(Review review) {
    // PROCEDIMENTO PRA DELETAR REVIEW
  }

  @override
  Widget build(BuildContext context) {
    List<Object> args =
        ModalRoute.of(context)!.settings.arguments as List<Object>;
    user = args[0] as User;
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
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  List<Review>? reviewList = snapshot.data;
                  if (reviewList!.isEmpty) {
                    return const Center(child: Icon(Icons.block));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: reviewList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(DateTime.now().microsecond.toString()),

                            // Aparência
                            background: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.edit, color: Colors.white)
                                ],
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: Colors.white)
                                ],
                              ),
                            ),

                            // Ações
                            onDismissed: (direction) {
                              // Atualizar review
                              if (direction == DismissDirection.startToEnd) {
                                updateReview(reviewList[index]);

                                // Remover review
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                deleteReview(reviewList[index]);
                                final snackBar = SnackBar(
                                  content: const Text("Review excluída!"),
                                  duration: const Duration(seconds: 5),
                                  action: SnackBarAction(
                                    label: "Desfazer",
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },

                            // Corpo
                            child: ListTile(
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
                                  const Icon(Icons.star,
                                      size: 20, color: Colors.amber),
                                ],
                              ),

                              // Descrição
                              subtitle: Text(reviewList[index].description),
                            ),
                          );
                        },
                      ),
                    );
                  }

                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
