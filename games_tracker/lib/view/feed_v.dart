import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

class FeedV extends StatefulWidget {
  const FeedV({super.key});
  @override
  State<FeedV> createState() => _FeedState();
}

class _FeedState extends State<FeedV> {
  
  // ADICIONAR NOVA FUNÇÃO
  List<Game> gameList = [];

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

        // Filtro
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Filtro"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Buscar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Resetar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),

      // Menu
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho de identificação
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person_2, size: 60),
              ),
              accountName: Text("Visitante"),
              accountEmail: Text(""),
            ),

            const SizedBox(height: 20),

            // Retornar
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.keyboard_return),
              label: const Text("Retornar"),
            )
          ],
        ),
      ),

      // Corpo
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Lista de Jogos
          Expanded(
            child: ListView.builder(
              itemCount: gameList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(5),

                  leading: const Icon(Icons.videogame_asset, size: 40),

                  // Informações
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Nome
                      Expanded(child: Text(gameList[index].name)),

                      // Média
                      Row(
                        children: [
                          Text(
                            // INSERIR MÉDIA
                            "${index * 1.5} ",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                        ],
                      ),
                    ],
                  ),

                  // Entrar na página
                  onTap: () {
                    Navigator.of(context).pushNamed("/game_page_visitante",
                        arguments: gameList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
