import 'package:flutter/material.dart';
import 'package:games_tracker/controller/user_controller.dart';
import 'package:games_tracker/model/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

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
                controller: _emailController,
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
                controller: _senhaController,
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
                  User? user;
                  user = await UserController.findUser(
                      _emailController.text, _senhaController.text);

                  if (user != null) {
                    print('FOI PRA PRÓXIMA PÁGINA!');
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextPage(user),
                        ),
                      );*/
                  } else {
                    _showMessage("Esta conta não existe!");
                  }
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