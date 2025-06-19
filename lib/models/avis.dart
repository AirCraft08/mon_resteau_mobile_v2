class Avis {
  final int id;
  final String auteur;
  final String commentaire;
  final int note;
  final String restaurantNom;
  final int restaurantId; // ajouté pour la navigation
  final String createdAt;

  Avis({
    required this.id,
    required this.auteur,
    required this.commentaire,
    required this.note,
    required this.restaurantNom,
    required this.restaurantId,
    required this.createdAt,
  });

  factory Avis.fromJson(Map<String, dynamic> json) {
    return Avis(
      id: json['id'],
      auteur: json['auteur'] ?? 'Anonyme',
      commentaire: json['commentaire'] ?? '',
      note: json['note'] ?? 0,
      restaurantNom: json['restaurant_nom'] ?? '',
      restaurantId: json['restaurant_id'] ?? 0, // récupéré depuis l'API
      createdAt: json['created_at'] ?? '',
    );
  }
}
