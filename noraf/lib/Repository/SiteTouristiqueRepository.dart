import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/ImageSite.dart';
import '../Model/SiteTouristique.dart';
import '../Page/Site/PageImageSite.dart';


class SiteTouristiqueRepository {
  final CollectionReference _siteCollection =
      FirebaseFirestore.instance.collection('sitetouristiques');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> ajouterSite(SiteTouristique site, File imageFile,
      {required context}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user != null ? user.uid : '';
      final docRef = _siteCollection.doc();
      final sitetId = docRef.id;
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('sitetouristiques')
          .child(sitetId + '.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      await docRef.set({
        ...site.toMap(),
        'id_site': sitetId,
        'admin_id': userId,
        'image': imageUrl,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PageImageSite(id_site_touristique: sitetId)),
      );
    } else {
      print("connectez vous pour faire un ajout");
    }
  }

  Stream<List<ImageSite>> readAllSiteImage(String id_logement)=>FirebaseFirestore.instance.collection('Images').where("id_site_touristique",isEqualTo: id_logement).snapshots().map((snapshot) => snapshot.docs.map((doc) =>ImageSite.fromMap(doc.data())).toList());



  Stream<List<SiteTouristique>> obtenirTousLesSites() {
    return _siteCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (data is Map<String, dynamic>) {
          return SiteTouristique.fromMap(data);
        } else {
          throw FormatException('Données incorrectes pour le site');
        }
      }).toList();
    });
  }

  Future<void> mettreAJourSite(SiteTouristique sites, File? imageFile) async {
    if (imageFile != null) {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('sitetouristiques')
          .child(sites.id_site + '.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      SiteTouristique sitetMisAJour = SiteTouristique(
          id_site: sites.id_site,
          nom: sites.nom,
          description: sites.description,
          histoire: sites.histoire,
          localite: sites.localite,
          region: sites.region,
          image: imageUrl,
          coordonnees: sites.coordonnees);

      await _siteCollection.doc(sites.id_site).update(sitetMisAJour.toMap());
    } else {
      await _siteCollection.doc(sites.id_site).update(sites.toMap());
    }
  }

  Future<void> supprimerSite(String siteId) async {
    await _siteCollection.doc(siteId).delete();
  }
}
