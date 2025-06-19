import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_provider.dart';
import 'screens/restaurant_list_screen.dart';
import 'screens/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MonRestau',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RestaurantListScreen(),  // Sans const car le constructeur n’est pas const
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
