import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageSite {
  final String id_image_site;
  final String id_site_touristique;
  final String image1;
  final String image2;
  final String image3;
  final String image4;

  ImageSite({
    required this.id_image_site,
    required this.id_site_touristique,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
  });

  // Méthode pour convertir le modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'id_image_site': id_image_site,
      'id_site_touristique': id_site_touristique,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'image4': image4,
    };
  }

  // Méthode pour créer une instance de modèle à partir d'un Map
  static ImageSite fromMap(Map<String, dynamic> map) {
    return ImageSite(
      id_image_site: map['id_image_site'],
      id_site_touristique: map['id_site_touristique'],
      image1: map['image1'],
      image2: map['image2'],
      image3: map['image3'],
      image4: map['image4'],
    );
  }
}
