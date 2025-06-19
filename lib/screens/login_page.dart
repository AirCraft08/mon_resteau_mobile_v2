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

    // Ici tu peux ajouter la vraie logique API d’authentification
    // Pour l’instant, simule que temp1@test.com avec n’importe quel mdp est userId 207
    // Sinon userId 1 (admin)

    int userId = 1;
    String username = 'Admin';

    if (email == 'temp1@test.com') {
      userId = 207;
      username = 'temp1';
    } else if (email.isNotEmpty) {
      username = email;
    }

    // Mise à jour du provider
    Provider.of<UserProvider>(context, listen: false).login(userId, username);

    // Navigation vers la liste des restaurants
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RestaurantListScreen()),
    );
  }
e
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
