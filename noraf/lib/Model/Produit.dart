import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  final String id;
  final String image;
  final String nom;
  final int prix;
  final String coordonneevendeur;
  final String description;
  final String type;
  final bool statut;
  final String utilisateurId;

  Produit({
    required this.id,
    required this.image,
    required this.nom,
    required this.prix,
    required this.coordonneevendeur,
    required this.description,
    required this.type,
    this.statut = true,
    required this.utilisateurId,
  });

  // Méthode pour convertir le modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'nom': nom,
      'prix': prix,
      'coordonneevendeur': coordonneevendeur,
      'description': description,
      'type': type,
      'statut': statut,
      'utilisateurId': utilisateurId
    };
  }

  // Méthode pour créer une instance de modèle à partir d'un Map
  static Produit fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'],
      image: map['image'],
      nom: map['nom'],
      prix: map['prix'],
      coordonneevendeur: map['coordonneevendeur'],
      description: map['description'],
      type: map['type'],
      statut: map['statut'], utilisateurId: map['utilisateurId'],
    );
  }
}
