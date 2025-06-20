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
  late TextEditingController prixMoyenController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController contactNomController;
  late TextEditingController contactEmailController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.restaurant.nom);
    descriptionController = TextEditingController(text: widget.restaurant.description);
    prixMoyenController = TextEditingController(text: widget.restaurant.prixMoyen.toString());
    latitudeController = TextEditingController(text: widget.restaurant.latitude.toString());
    longitudeController = TextEditingController(text: widget.restaurant.longitude.toString());
    contactNomController = TextEditingController(text: widget.restaurant.contactNom);
    contactEmailController = TextEditingController(text: widget.restaurant.contactEmail);
  }

  void _save() async {
    double? prixMoyen = double.tryParse(prixMoyenController.text);
    double? latitude = double.tryParse(latitudeController.text);
    double? longitude = double.tryParse(longitudeController.text);

    if (prixMoyen == null || latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prix moyen, latitude et longitude doivent être des nombres valides')),
      );
      return;
    }

    final updatedRestaurant = Restaurant(
      id: widget.restaurant.id,
      nom: nomController.text,
      description: descriptionController.text,
      dateOuverture: widget.restaurant.dateOuverture,
      prixMoyen: prixMoyen,
      latitude: latitude,
      longitude: longitude,
      contactNom: contactNomController.text,
      contactEmail: contactEmailController.text,
      photo: widget.restaurant.photo,
      moyenneNote: widget.restaurant.moyenneNote,
    );

    try {
      await ApiService().updateRestaurant(updatedRestaurant);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(
              controller: prixMoyenController,
              decoration: const InputDecoration(labelText: 'Prix moyen'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(controller: contactNomController, decoration: const InputDecoration(labelText: 'Contact nom')),
            TextField(controller: contactEmailController, decoration: const InputDecoration(labelText: 'Contact email')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}
