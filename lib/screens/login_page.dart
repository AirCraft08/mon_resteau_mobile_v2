import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_provider.dart';
import 'restaurant_list_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // TODO : Remplacer cette simulation par un appel réel à ton API d’authentification
    int userId = 1;
    String username = 'Admin';
    String token = 'token_simulé_pour_tests'; // Simule un token

    if (email == 'temp1@test.com') {
      userId = 207;
      username = 'temp1';
      token = 'token_temp1';
    } else if (email.isNotEmpty) {
      username = email;
    }

    // Met à jour le provider avec l’identifiant, le nom et le token
    Provider.of<UserProvider>(context, listen: false).login(userId, username, token);

    // Navigue vers la liste des restaurants
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RestaurantListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
