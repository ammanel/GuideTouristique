
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Model/Produit.dart';

class ProduitRepository {
  final CollectionReference _produitCollection =
      FirebaseFirestore.instance.collection('produits');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> ajouterProduit(Produit produit, File imageFile) async {
    final user = _auth.currentUser;
    final userId = user != null ? user.uid : '';

    final docRef = _produitCollection.doc();
    final produitId = docRef.id;

    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('produits')
        .child(produitId + '.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    await docRef.set({
      ...produit.toMap(),
      'id': produitId,
      'utilisateurId': userId,
      'image': imageUrl,
    });
  }

  Stream<List<Produit>> obtenirTousLesProduits() {
    return _produitCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (data is Map<String, dynamic>) {
          return Produit.fromMap(data);
        } else {
          throw FormatException('Données incorrectes pour le produit');
        }
      }).toList();
    });
  }

  Stream<List<Produit>> readAllofMyProducts(String _auth)=>FirebaseFirestore.instance.collection('Produits').where("utilisateurId",isEqualTo: _auth).snapshots().map((snapshot) => snapshot.docs.map((doc) =>Produit.fromMap(doc.data())).toList());


  Future<void> mettreAJourProduit(Produit produit, File? imageFile) async {
    if (imageFile != null) {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('produits')
          .child(produit.id + '.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      Produit produitMisAJour = Produit(
        id: produit.id,
        nom: produit.nom,
        image: imageUrl,
        coordonneevendeur: produit.coordonneevendeur,
        prix: produit.prix,
        description: produit.description,
        type: produit.type, utilisateurId: _auth.currentUser!.uid,
      );

      await _produitCollection.doc(produit.id).update(produitMisAJour.toMap());
    } else {
      await _produitCollection.doc(produit.id).update(produit.toMap());
    }
  }

  Future<void> supprimerProduit(String produitId) async {
    await _produitCollection.doc(produitId).delete();
  }
}
