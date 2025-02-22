import 'package:flutter/material.dart';
import 'package:games_tracker/controller/game_controller.dart';
import 'package:games_tracker/controller/review_controller.dart';
import 'package:games_tracker/model/user.dart';
import 'package:games_tracker/model/game.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});
  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late User user;
  int op = 1;

  // Para o novo jogo
  TextEditingController _nameController = TextEditingController();
  TextEditingController _releaseDateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _genreController = TextEditingController();

  // Para o filtro
  late int opBackup;
  int _filterController = 2;
  TextEditingController _filterDataController = TextEditingController();

  // op = 0 pra lista do usuario
  // op = 1 pra lista geral
  // op = 2 pra lista selecionada por data
  // op = 3 pra lista selecionada por genero
  // op = 4 pra lista selecionada por média
  Future<List<Map<String, dynamic>>> getGames() async {
    List<Game> gameList = [];
    List<Map<String, dynamic>> gameListWithAverages = [];
    switch (op) {
      case 0:
        gameList = await GameController.objetifyTableGame(user.id);
        break;
      case 1:
        gameList = await GameController.objetifyTableGame(null);
        break;
      case 2:
        gameList =
            await GameController.objetifyFiltroData(_filterDataController.text);
        break;
      case 3:
        gameList = await GameController.objetifyFiltroGenero(
            _filterDataController.text);
        break;
      case 4:
        gameList = await GameController.testeFiltroMedia(
            user.id, _filterDataController.text);
        break;
      default:
        break;
    }
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

        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              opBackup = op;
              _filterController = 2;
              _filterDataController.text = "";
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("Filtrar por"),
                        scrollable: true,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filtro de ano
                            RadioListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              value: 2,
                              title: const Text("Ano de lançamento"),
                              groupValue: _filterController,
                              onChanged: (value) {
                                setState(() {
                                  _filterController = value!;
                                });
                              },
                            ),
                            TextField(
                              controller: _filterDataController,
                              keyboardType: TextInputType.number,
                              enabled: (_filterController == 2),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            // Filtro de genero
                            RadioListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              value: 3,
                              title: const Text("Gênero"),
                              groupValue: _filterController,
                              onChanged: (value) {
                                setState(() {
                                  _filterController = value!;
                                });
                              },
                            ),
                            TextField(
                              controller: _filterDataController,
                              keyboardType: TextInputType.text,
                              enabled: (_filterController == 3),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.extension),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            // Filtro de média
                            RadioListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              value: 4,
                              title: const Text("Média"),
                              groupValue: _filterController,
                              onChanged: (value) {
                                setState(() {
                                  _filterController = value!;
                                });
                              },
                            ),
                            TextField(
                              controller: _filterDataController,
                              keyboardType: TextInputType.number,
                              enabled: (_filterController == 4),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.star),
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
                            child: const Text("Buscar"),
                            onPressed: () {
                              op = _filterController;
                              Navigator.pop(context);
                            },
                          ),

                          // Botão de reset
                          TextButton(
                            child: const Text("Resetar"),
                            onPressed: () {
                              setState(() {
                                _filterController = 2;
                                op = 1;
                                _filterDataController.text = "";
                              });
                              Navigator.pop(context);
                            },
                          ),

                          // Botão de cancelamento
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () {
                              setState(() {
                                _filterController = 2;
                                op = opBackup;
                                _filterDataController.text = "";
                              });
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

            //Todos os jogos
            TextButton(
              onPressed: () {
                op = 1;
                setState(() {});
              },
              child: const Text("Todos os jogos"),
            ),

            // Meus jogos
            TextButton(
              onPressed: () {
                op = 0;
                setState(() {});
              },
              child: const Text("Meus jogos"),
            ),

            // Minha reviews
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  "/reviews_page",
                  arguments: [user, 0],
                );
              },
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
          _nameController.text = "";
          _releaseDateController.text = "";
          _descriptionController.text = "";
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
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

                    // Campo do lançamento
                    TextField(
                      controller: _releaseDateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month),
                        labelText: "Data de lançamento",
                        hintText: "aaaa-mm-dd",
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
                          _showMessage(
                              "Cadastro do jogo realizado com sucesso!");
                        } else {
                          _showMessage(
                              "Não foi possível realizar o cadastro do jogo, tente novamente.");
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),

                  // Botão de cancelamento
                  TextButton(
                    child: const Text("Cancelar"),
                    onPressed: () {
                      _nameController.text = "";
                      _releaseDateController.text = "";
                      _descriptionController.text = "";
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
                              "/game_page",
                              arguments: [
                                user,
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
