import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/avis.dart';

class ApiService {
  // Remplace par l'IP locale de ta machine si tu utilises un émulateur ou un vrai appareil
  static const String baseUrl = "http://127.0.0.1:8000/api";

  /// Récupère la liste des restaurants
  Future<List<dynamic>> getRestaurants() async {
    final url = Uri.parse('$baseUrl/restaurants');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des restaurants');
    }
  }

  /// Met à jour un restaurant sans authentification ni CSRF
  Future<void> updateRestaurant(Restaurant r) async {
    final url = Uri.parse('$baseUrl/restaurants/${r.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',  // Important pour recevoir du JSON en réponse
      },
      body: jsonEncode({
        'nom': r.nom,
        'description': r.description,
        'prix_moyen': r.prixMoyen,
        'latitude': r.latitude,
        'longitude': r.longitude,
        'contact_nom': r.contactNom,
        'contact_email': r.contactEmail,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur lors de la mise à jour du restaurant');
    }
  }

  /// Met à jour un avis sans authentification ni CSRF
  Future<void> updateAvis(Avis a) async {
    final url = Uri.parse('$baseUrl/avis/${a.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',  // Important pour recevoir du JSON en réponse
      },
      body: jsonEncode({
        'note': a.note,
        'commentaire': a.commentaire,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur lors de la mise à jour de l\'avis');
    }
  }
}
