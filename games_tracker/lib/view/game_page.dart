import 'package:flutter/material.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';
import 'package:games_tracker/model/review.dart';

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

  // Lista de reviews
  late List<Review> reviewList;

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
              return AlertDialog(
                title: const Text("Adicionar review"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nota"),
                    Slider(
                      value: _scoreController,
                      min: 0,
                      max: 10,
                      divisions: 21,
                      onChanged: (value) {
                        _scoreController = value;
                      },
                    ),

                    // Espaço
                    const SizedBox(height: 15),

                    // Descrição
                    TextField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      maxLength: null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.description),
                        labelText: "Comentários",
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
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
                      children: [Icon(Icons.delete, color: Colors.white)],
                    ),
                  ),
                  
                  // Ações
                  onDismissed: (direction) {
                    // Atualizar review
                    if (direction == DismissDirection.startToEnd) {
  
                    // Remover review
                    } else if (direction == DismissDirection.endToStart) {
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
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        const Icon(Icons.star, size: 20, color: Colors.amber),
                      ],
                    ),

                    // Descrição
                    subtitle: Text(reviewList[index].description),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
