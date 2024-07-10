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

  // TODO Lista de jogos:
  // op = 0 pra lista do usuario
  // op = 1 pra lista geral
  // op = 2 pra lista selecionada por data
  // op = 3 pra lista selecionada por genero
  // op = 4 pra lista selecionada por média
  Future<List<Game>> getGames() async {
    List<Game> gameList = [];
    switch (op) {
      case 0:
        gameList = await GameController.objetifyTableGame(user.id);
        break;
      case 1:
        gameList = await GameController.objetifyTableGame(null);
        break;
      case 2:
        gameList = await GameController.objetifyFiltroData('2022');//TODO DESCOBRIR COMO USAR LIKE OU USAR METODO  DE BUSCA DE SUBSTRING
        break;
      case 3:
        gameList = await GameController.objetifyFiltroGenero('RPG');//TODO VER PARAMETRO BEA
        break;
      default:
        break;
    }
    return gameList;
  }

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

        // TODO Filtro
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              opBackup = op;
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
                              onTap: () {
                                _filterDataController = TextEditingController();
                              },
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
                              onTap: () {
                                _filterDataController = TextEditingController();
                              },
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
                              onTap: () {
                                _filterDataController = TextEditingController();
                              },
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
                                op = 0;
                                _filterDataController = TextEditingController();
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
                                _filterDataController = TextEditingController();
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

                    // Campo do ano de lançamento
                    TextField(
                      controller: _releaseDateController,
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
          FutureBuilder(
            future: getGames(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  List<Game>? gameList = snapshot.data;
                  if (gameList!.isEmpty) {
                    return const Center(child: Icon(Icons.videogame_asset_off));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: gameList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.all(5),
                            leading:
                                const Icon(Icons.videogame_asset, size: 40),

                            // Informações
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Nome
                                Expanded(child: Text(gameList![index].name)),

                                // Média
                                const Row(
                                  children: [
                                    Text(
                                      // TODO inserir média (tirar const da row)
                                      "inserir média",
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
                                arguments: [user, gameList[index]],
                              );
                            },
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
