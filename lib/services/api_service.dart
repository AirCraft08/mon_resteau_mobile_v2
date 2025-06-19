import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/avis.dart';

class ApiService {
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

  /// Met à jour un restaurant
  Future<void> updateRestaurant(Restaurant r) async {
    final url = Uri.parse('$baseUrl/restaurants/${r.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': r.nom,
        'description': r.description,
        // ajoute d'autres champs si besoin
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur mise à jour restaurant');
    }
  }

  /// Met à jour un avis
  Future<void> updateAvis(Avis a) async {
    final url = Uri.parse('$baseUrl/avis/${a.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'note': a.note,
        'commentaire': a.commentaire,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur mise à jour avis');
    }
  }
}
