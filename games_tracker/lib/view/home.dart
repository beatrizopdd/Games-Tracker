import 'package:flutter/material.dart';
import 'package:games_tracker/controller/database_controller.dart';
import 'register.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.redAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título do menu
                  const Text(
                    'Games Tracker',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  // Espaço
                  const SizedBox(height: 20),

                  // Botão de login
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),

                  // Espaço
                  const SizedBox(height: 10),

                  // Botão de cadastro
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: const Icon(Icons.app_registration),
                    label: const Text('Cadastro'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                  ),

                  // Espaço
                  const SizedBox(height: 20),

                  // Botão de acesso como visitante
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/feed_visitante');
                    },
                    child: const Text(
                      'Acessar sem login',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),

                  // Botões de testes no Banco de Dados
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () async {
                      await DatabaseController.db; // Certifique-se de que o banco de dados está inicializado
                      // Imprima o conteúdo de outras tabelas conforme necessário
                      print('User:');
                      await DatabaseController.printTable('user');
                      print('Genre:');
                      await DatabaseController.printTable('genre');
                      print('Game:');
                      await DatabaseController.printTable('game');
                      print('Game_Genre:');
                      await DatabaseController.printTable('game_genre');
                      print('Review');
                      await DatabaseController.printTable('review');
                    },
                    child: const Text(
                      'Testa Banco de Dados',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () async {
                      await DatabaseController.deleteDatabaseFile();
                    },
                    child: const Text(
                      'Apaga Banco de Dados',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
