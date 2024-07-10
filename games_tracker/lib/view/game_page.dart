import 'package:flutter/material.dart';
import 'package:games_tracker/model/review.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late User user;
  late Game game;

  // Para a nova review
  double _scoreController = 0;
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Object> args =
        ModalRoute.of(context)!.settings.arguments as List<Object>;
    user = args[0] as User;
    game = args[1] as Game;

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

        // Botão de deletar jogo
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // PROCEDIMENTO PRA APAGAR
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
                          maxLength: null,
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
                          Navigator.pop(context);
                        },
                      ),

                      // Botão de cancelamento
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          _scoreController = 0;
                          _descriptionController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // Lançamento
            Row(
              children: [
                const Text(
                  "LANÇAMENTO: ",
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
            const Row(
              children: [
                const Text(
                  "MÉDIA: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                // INSERIR MÉDIA
                Text(
                  "inserir média",
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
      ),
    );
  }
}
