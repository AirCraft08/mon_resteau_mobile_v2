import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class EditRestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;

  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  late TextEditingController nomController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.restaurant.nom);
    descriptionController = TextEditingController(text: widget.restaurant.description);
  }

  void _save() async {
    final updatedRestaurant = Restaurant(
      id: widget.restaurant.id,
      nom: nomController.text,
      description: descriptionController.text,
      dateOuverture: widget.restaurant.dateOuverture,
      prixMoyen: widget.restaurant.prixMoyen,
      latitude: widget.restaurant.latitude,
      longitude: widget.restaurant.longitude,
      contactNom: widget.restaurant.contactNom,
      contactEmail: widget.restaurant.contactEmail,
      photo: widget.restaurant.photo,
    );

    try {
      await ApiService().updateRestaurant(updatedRestaurant);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}
