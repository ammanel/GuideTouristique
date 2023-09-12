import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Evenement {
  final String id_evenement;
  final String image;
  final String nom;
  final String region;
  final LatLng coordonnees;
  final String description;
  final DateTime date_debut;
  final DateTime date_fin;
  final bool story;
  final bool statut;

  Evenement({
    required this.id_evenement,
    required this.image,
    required this.nom,
    required this.region,
    required this.coordonnees,
    required this.description,
    required this.date_debut,
    required this.date_fin,
    this.statut = true,
    this.story = false,
  });

  // Méthode pour convertir le modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'id_evenement': id_evenement,
      'image': image,
      'nom': nom,
      'region': region,
      'latitude': coordonnees.latitude,
      'longitude': coordonnees.longitude,
      'description': description,
      'date_debut': date_debut,
      'date_fin': date_fin,
      'statut': statut,
      'story':story,
    };
  }

  // Méthode pour créer une instance de modèle à partir d'un Map
  static Evenement fromMap(Map<String, dynamic> map) {
    return Evenement(
      id_evenement: map['id_evenement'],
      image: map['image'],
      nom: map['nom'],
      region: map['region'],
      coordonnees: LatLng(map['latitude'], map['longitude']),
      description: map['description'],
      date_debut: (map['date_debut']as Timestamp).toDate(),
      date_fin: (map['date_fin']as Timestamp).toDate(),
      statut: map['statut'],
      story: map['story'],
    );
  }
}
