// restaurant.dart
class Restaurant {
  final int id;
  final String nom;
  final String description;
  final String dateOuverture;
  final double prixMoyen;
  final double latitude;
  final double longitude;
  final String contactNom;
  final String contactEmail;
  final String? photo; // Nullable
  final double? moyenneNote; // Nullable note moyenne

  Restaurant({
    required this.id,
    required this.nom,
    required this.description,
    required this.dateOuverture,
    required this.prixMoyen,
    required this.latitude,
    required this.longitude,
    required this.contactNom,
    required this.contactEmail,
    this.photo,
    this.moyenneNote,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      dateOuverture: json['date_ouverture'] ?? '',
      prixMoyen: double.tryParse(json['prix_moyen'].toString()) ?? 0.0,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      contactNom: json['contact_nom'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      photo: json['photo'],
      moyenneNote: json['moyenne_note'] != null ? double.tryParse(json['moyenne_note'].toString()) : null,
    );
  }
}
