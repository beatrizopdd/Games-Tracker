import 'package:flutter/material.dart';
import 'package:games_tracker/database/database_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.redAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo do email
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),

              // Espaço
              const SizedBox(height: 10),

              // Campo da senha
              TextField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),

              // Espaço
              const SizedBox(height: 20),

              // Botão de envio
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Color(0x00000000),
                ),
                onPressed: () async {
                  DatabaseService dbService = DatabaseService();
                  final path = await dbService.fullPath;
                  //await deleteDatabase(path);
                  print(path);

                  // Inicialize o banco de dados e crie tabelas
                  await dbService.database;

                  // Imprima todas as tabelas no terminal
                  await dbService.printAllTables();
                  // Implementar a lógica de login
                },
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.black26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
