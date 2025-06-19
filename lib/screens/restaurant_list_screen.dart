import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_provider.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';
import 'profile_page.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  // Pas de constructeur const ici
  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  late Future<List<Restaurant>> restaurants;

  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants();
  }

  Future<List<Restaurant>> fetchRestaurants() async {
    final data = await ApiService().getRestaurants();
    return data.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          if (!userProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.login),
              tooltip: 'Connexion',
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(child: Text(userProvider.username)),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Profil',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      userId: userProvider.userId,
                      username: userProvider.username,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Déconnexion',
              onPressed: () {
                userProvider.logout();
              },
            ),
          ],
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: restaurants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun restaurant trouvé'));
          }

          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final r = list[index];
              final imageUrl = (r.photo != null && r.photo!.isNotEmpty)
                  ? 'http://127.0.0.1:8000/api/image/${r.photo!.split('/').last}'
                  : null;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(restaurant: r),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.nom, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text("Prix moyen : ${r.prixMoyen} €"),
                        Text("Note moyenne : ${r.moyenneNote ?? 0} ⭐"),
                        if (imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Image.network(
                              imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Text('Image indisponible'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
