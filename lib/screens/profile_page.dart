import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'edit_restaurant_screen.dart';
import '../models/restaurant.dart';
import '../models/avis.dart';
import 'restaurant_detail_screen.dart';
import 'edit_restaurant_screen.dart';
import 'edit_avis_screen.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  final String username;

  const ProfilePage({super.key, required this.userId, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Restaurant> mesRestaurants = [];
  List<Avis> mesAvis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final restosResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/utilisateur/${widget.userId}/restaurants'),
      );

      final avisResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/utilisateur/${widget.userId}/avis'),
      );

      if (restosResponse.statusCode == 200) {
        final List restosJson = jsonDecode(restosResponse.body);
        mesRestaurants = restosJson.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        print('Erreur récupération restaurants : ${restosResponse.statusCode}');
      }

      if (avisResponse.statusCode == 200) {
        final List avisJson = jsonDecode(avisResponse.body);
        mesAvis = avisJson.map((json) => Avis.fromJson(json)).toList();
      } else {
        print('Erreur récupération avis : ${avisResponse.statusCode}');
      }

    } catch (e) {
      print('Erreur fetch profil : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToRestaurantDetail(Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
      ),
    );
  }

  void _goToRestaurantDetailFromAvis(Avis avis) {
    final restaurant = Restaurant(
      id: avis.restaurantId,
      nom: avis.restaurantNom,
      description: '',
      dateOuverture: '',
      prixMoyen: 0,
      latitude: 0,
      longitude: 0,
      contactNom: '',
      contactEmail: '',
      photo: null,
    );
    _goToRestaurantDetail(restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil de ${widget.username}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mes restaurants créés :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (mesRestaurants.isEmpty)
              const Text("Vous n'avez pas encore créé de restaurant."),
            ...mesRestaurants.map((r) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(r.nom),
                subtitle: Text(r.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: const Text('Voir'),
                      onPressed: () => _goToRestaurantDetail(r),
                    ),
                    TextButton(
                      child: const Text('Modifier'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditRestaurantScreen(restaurant: r),
                        ),
                      ).then((_) => fetchData()),
                    ),
                  ],
                ),
              ),
            )),
            const Divider(height: 32),
            const Text("Mes avis :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (mesAvis.isEmpty)
              const Text("Vous n'avez pas encore laissé d'avis."),
            ...mesAvis.map((a) => Card(
              color: Colors.orange.shade50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  "Restaurant : ${a.restaurantNom} - ${a.note} ⭐",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (a.commentaire.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(a.commentaire),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "Par : ${a.auteur}",
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                    if (a.createdAt.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          a.createdAt,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Voir'),
                          onPressed: () => _goToRestaurantDetailFromAvis(a),
                        ),
                        TextButton(
                          child: const Text('Modifier'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditAvisScreen(avis: a),
                            ),
                          ).then((_) => fetchData()),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
