import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SiteTouristique {
  final String id_site;
  final String nom;
  final String description;
  final String histoire;
  final String localite;
  final String region;
  final String image;
  final LatLng coordonnees;

  SiteTouristique({
    required this.id_site,
    required this.nom,
    required this.description,
    required this.histoire,
    required this.localite,
    required this.region,
    required this.image,
    required this.coordonnees,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_site': id_site,
      'nom': nom,
      'description': description,
      'histoire': histoire,
      'localite': localite,
      'region': region,
      'image': image,
      'latitude': coordonnees.latitude,
      'longitude': coordonnees.longitude,
    };
  }

  static SiteTouristique fromMap(Map<String, dynamic> map) {
    return SiteTouristique(
      id_site: map['id_site'],
      nom: map['nom'],
      description: map['description'],
      histoire: map['histoire'],
      localite: map['localite'],
      region: map['region'],
      image: map['image'],
      coordonnees: LatLng(map['latitude'], map['longitude']),
    );
  }
}
