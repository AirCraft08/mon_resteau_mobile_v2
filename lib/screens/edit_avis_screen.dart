import 'package:flutter/material.dart';
import '../models/avis.dart';
import '../services/api_service.dart';

class EditAvisScreen extends StatefulWidget {
  final Avis avis;

  const EditAvisScreen({super.key, required this.avis});

  @override
  State<EditAvisScreen> createState() => _EditAvisScreenState();
}

class _EditAvisScreenState extends State<EditAvisScreen> {
  late TextEditingController noteController;
  late TextEditingController commentaireController;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.avis.note.toString());
    commentaireController = TextEditingController(text: widget.avis.commentaire);
  }

  void _save() async {
    int note = int.tryParse(noteController.text) ?? 0;
    if (note < 0 || note > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note doit être entre 0 et 5')),
      );
      return;
    }

    final updatedAvis = Avis(
      id: widget.avis.id,
      auteur: widget.avis.auteur,
      commentaire: commentaireController.text,
      note: note,
      restaurantNom: widget.avis.restaurantNom,
      restaurantId: widget.avis.restaurantId,
      createdAt: widget.avis.createdAt,
    );

    try {
      await ApiService().updateAvis(updatedAvis);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier l\'avis')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Note (0-5)'),
            ),
            TextField(
              controller: commentaireController,
              decoration: const InputDecoration(labelText: 'Commentaire'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}
