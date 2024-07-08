import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late User user;

  // Para o novo jogo
  TextEditingController _nameController = TextEditingController();
  TextEditingController _releaseDateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _genreController = TextEditingController();

  // Lista de jogos
  List<Game> gameList = [];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duração do SnackBar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as User;

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
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person_rounded, size: 60),
              ),
              accountName: Text(user.name),
              accountEmail: Text(user.email),
            ),

            const SizedBox(height: 20),

            // Meus jogos
            TextButton(
              onPressed: () {},
              child: const Text("Meus jogos"),
            ),

            // Minha reviews
            TextButton(
              onPressed: () {},
              child: const Text("Minhas reviews recentes"),
            ),

            const SizedBox(height: 20),

            // Logout
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            )
          ],
        ),
      ),

      // Botão flutuante
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.sports_esports, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Adicionar jogo"),

                // Campos para preenchimento
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo do nome
                    TextField(
                      controller: _nameController,
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
                      controller: _releaseDateController,
                      keyboardType: TextInputType.text,
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
                      controller: _descriptionController,
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
                      controller: _genreController,
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
                    child: const Text("Adicionar"),
                    onPressed: () async {
                      int result = await GameController.cadastraGame(
                          user.id,
                          _nameController.text,
                          _descriptionController.text,
                          _releaseDateController.text,
                          _genreController.text);

                      if (result == -1) {
                        _showMessage("O jogo já está cadastrado no sistema!");
                      } else {
                      if (result != 0) {
                        _showMessage("Cadastro do jogo realizado com sucesso!");
                      } else {
                      _showMessage(
                          "Não foi possível realizar o cadastro do jogo, tente novamente.");
                    }
                    }
                      // INSERE NO BANCO DE DADOS
                      Navigator.pop(context);
                    },
                  ),

                  // Botão de cancelamento
                  TextButton(
                    child: const Text("Cancelar"),
                    onPressed: () {
                      _nameController = TextEditingController();
                      _releaseDateController = TextEditingController();
                      _descriptionController = TextEditingController();
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
                    Navigator.of(context).pushNamed("/game_page",
                        arguments: [user, gameList[index]]);
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
