import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/avis.dart';
import '../models/restaurant.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  List<Avis> avisList = [];

  @override
  void initState() {
    super.initState();
    fetchAvis();
  }

  Future<void> fetchAvis() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/restaurants/${widget.restaurant.id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> avisJson = data['restaurant']['avis'];
        setState(() {
          avisList = avisJson.map((json) => Avis.fromJson(json)).toList();
        });
      } else {
        print("Erreur API : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors du chargement des avis : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final imageUrl = (r.photo != null && r.photo!.isNotEmpty)
        ? 'http://127.0.0.1:8000/api/image/${r.photo!.split('/').last}'
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(r.nom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Text('Image indisponible'),
                ),
              ),
            const SizedBox(height: 16),
            Text(r.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Prix moyen : ${r.prixMoyen.toStringAsFixed(2)} €'),
            Text('Ouvert depuis le ${r.dateOuverture}'),
            Text('Contact : ${r.contactNom} (${r.contactEmail})'),
            Text("Note moyenne : ${r.moyenneNote ?? 0} ⭐"),
            const SizedBox(height: 16),
            const Divider(),
            const Text("Avis des clients :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            avisList.isEmpty
                ? const Text("Aucun avis pour ce restaurant.")
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: avisList.length,
              itemBuilder: (context, index) {
                final avis = avisList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('${avis.auteur} – ${avis.note} ⭐'),
                    subtitle: Text(avis.commentaire),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
