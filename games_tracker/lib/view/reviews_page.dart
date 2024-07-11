import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/controller/user_controller.dart';
import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/review.dart';
//import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/controller/review_controller.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late User user;
  late List<User> reviewAuthor;
  late List<Game> reviewGame;
  late int game_id;

  // Para a atualização da review
  late double _newScoreController;
  TextEditingController _newDescriptionController = TextEditingController();

  // Lista de reviews
  // pra diferenciar se vem do feed (Minhas reviews recentes) ou do jogo (Ver reviewes)
  // ver se game_id == 0

  Future<List<Review>> getReviews() async {
    List<Review> reviewList = [];

    switch (game_id) {
      case 0:
        reviewList = await ReviewController.objetifyTableReviewbyUser(user.id);
        break;
      default:
        reviewList = await ReviewController.objetifyTableReviewbyGame(game_id);
        break;
    }


    for (Review review in reviewList) {
      User? author = await UserController.findUserByID(review.user_id);
      reviewAuthor.add(author);
      Game? game = await GameController.findGameID(review.game_id);
      reviewGame.add(game!);
    }
  
    return reviewList;
  }

  // Atualizar review
  void updateReview(Review review) {
    if (review.user_id == user.id) {
      _newScoreController = review.score;
      _newDescriptionController.text = review.description;
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Editar review"),
                scrollable: true,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nota"),
                    Slider(
                      label: _newScoreController.toString(),
                      value: _newScoreController,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _newScoreController = value;
                        });
                      },
                    ),

                    // Espaço
                    const SizedBox(height: 10),

                    // Descrição
                    TextField(
                      controller: _newDescriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description),
                        labelText: "Comentário",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),

                // Botões
                actions: [
                  // Botão de envio
                  TextButton(
                    child: const Text("Editar"),
                    onPressed: () async {
                      review = (await ReviewController.atualizaReview(
                          (_newScoreController),
                          _newDescriptionController.text,
                          DateTime.now.toString(),
                          review.id,
                          review.game_id,
                          review.user_id))!;
                      Navigator.pop(context);
                    },
                  ),

                  // Botão de cancelamento
                  TextButton(
                    child: const Text("Cancelar"),
                    onPressed: () {
                      _newScoreController = review.score;
                      _newDescriptionController.text = review.description;
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você não pode editar esta review!"),
          duration: Duration(seconds: 2), // Duração do SnackBar
        ),
      );
    }
  }

  // Deletar review
  void deleteReview(Review review) {
    if (review.user_id == user.id) {
      ReviewController.deleteReviewbyId(review.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você não pode deletar esta review!"),
          duration: Duration(seconds: 2), // Duração do SnackBar
        ),
      );
    }
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
                        return Dismissible(
                          key: Key(DateTime.now().microsecond.toString()),

                          // Aparência
                          background: Container(
                            color: Colors.blue,
                            padding: const EdgeInsets.all(16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Icon(Icons.edit, color: Colors.white)],
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
                              const snackBar = SnackBar(
                                content: Text("Review excluída!"),
                                duration: Duration(seconds: 5),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },

                          // Corpo
                          child: ListTile(
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
                            title: const Text(
                              reviewAuthor[index].name,
                              style: const TextStyle(fontSize: 15),
                            ),

                            trailing: const Text(
                              reviewGame[index].name,
                              style: const TextStyle(fontSize: 15),
                            ),

                            // Descrição
                            subtitle: Text(reviewList[index].description),
                          ),
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
