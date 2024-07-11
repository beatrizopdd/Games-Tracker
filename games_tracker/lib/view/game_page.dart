import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

import '../controller/genre_controller.dart';
import '../controller/review_controller.dart';
/*import 'package:games_tracker/model/genre.dart';
import 'package:games_tracker/model/review.dart';*/

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late User user;
  late Game game;
  late String avg;

  // Para atualização do jogo
  TextEditingController _newNameController = TextEditingController();
  TextEditingController _newReleaseDateController = TextEditingController();
  TextEditingController _newDescriptionController = TextEditingController();
  TextEditingController _newGenreController = TextEditingController();

  // Para a nova review
  double _scoreController = 0;
  TextEditingController _descriptionController = TextEditingController();

  // Isso garante que o jogo esteja sempre atualizado
  Future<Game> updateGameData() async {
    game = (await GameController.findGameID(game.id))!;
    avg = (await ReviewController.mediaByGame(game.id))!;

    return game;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> args =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    user = args[0] as User;
    game = args[1] as Game;
    avg = args[2] as String;

    return Scaffold(
      // Nome do jogo
      appBar: AppBar(
        // Aparência
        foregroundColor: Colors.white,
        //centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Botão de deletar e atualizar o jogo
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              if (game.user_id == user.id) {
                String? game_gender_name =
                    await GameController.findGenreListfromGame(game.id);
                _newNameController.text = game.name;
                _newReleaseDateController.text = game.release_date;
                _newDescriptionController.text = game.description;
                _newGenreController.text = game_gender_name!;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text("Editar jogo"),

                      // Campos para preenchimento
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo do nome
                          TextField(
                            controller: _newNameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.edit),
                              labelText: "Nome",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Espaço
                          const SizedBox(height: 25),

                          // Campo do ano de lançamento
                          TextField(
                            controller: _newReleaseDateController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.calendar_month),
                              labelText: "Ano de lançamento",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Espaço
                          const SizedBox(height: 25),

                          // Campo da descrição
                          TextField(
                            controller: _newDescriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.description),
                              labelText: "Descrição",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Espaço
                          const SizedBox(height: 25),

                          // Campo de Gênero
                          TextField(
                            controller: _newGenreController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.extension),
                              labelText: "Gênero",
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
                            //String? game_gender_name = await GameController.findGenreListfromGame(game);
                            //_newGenreController.text = genrefudido;
                            //GameController.cadastraGame(user.id, _newNameController.text, _newDescriptionController.text, _newReleaseDateController.text,_newGenreController.text);

                            //Aventura- Aventura,RPG
                            _newGenreController.text =
                                await GenreController.updategenre(
                                    _newGenreController.text, game.id);

                            await GameController.updategame(
                                _newNameController.text,
                                _newDescriptionController.text,
                                _newReleaseDateController.text,
                                game.id);

                            Navigator.of(context).pop();
                          },
                        ),

                        // Botão de cancelamento
                        TextButton(
                          child: const Text("Cancelar"),
                          onPressed: () {
                            _newNameController.text = game.name;
                            _newReleaseDateController.text = game.release_date;
                            _newDescriptionController.text = game.description;
                            _newGenreController.text = game_gender_name;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Você não pode editar este jogo!"),
                    duration: Duration(seconds: 2), // Duração do SnackBar
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              if (game.user_id == user.id) {
                await GameController.deleteGame(game.name);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Você não pode deletar este jogo!"),
                    duration: Duration(seconds: 2), // Duração do SnackBar
                  ),
                );
              }
            },
          ),
        ],
      ),

      // Botão flutuante
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.rate_review, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Adicionar review"),
                    scrollable: true,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nota"),
                        Slider(
                          label: _scoreController.toString(),
                          value: _scoreController,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          onChanged: (value) {
                            setState(() {
                              _scoreController = value;
                            });
                          },
                        ),

                        // Espaço
                        const SizedBox(height: 10),

                        // Descrição
                        TextField(
                          controller: _descriptionController,
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
                        child: const Text("Avaliar"),
                        onPressed: () {
                          ReviewController.insertReview(
                              user.id,
                              game.id,
                              _descriptionController.text,
                              _scoreController,
                              DateTime.now().toString());
                          Navigator.of(context).pop();
                          _scoreController = 0;
                          _descriptionController.text = "";
                        },
                      ),

                      // Botão de cancelamento
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          _scoreController = 0;
                          _descriptionController.text = "";
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
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
                  const SizedBox(height: 15),

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
                        "${game.user_id}",
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
                    style: const TextStyle(fontSize: 16),
                  ),

                  // Ver reviews
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              "/reviews_page",
                              arguments: [user, game.id],
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
