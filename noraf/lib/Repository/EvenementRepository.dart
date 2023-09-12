import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/Evenement.dart';
import '../Page/Evenement/ListeEvenement.dart';



class EvenementRepository {
  final CollectionReference _evenementCollection =
      FirebaseFirestore.instance.collection('Evenements');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> ajouterEvenement(Evenement evenement, File imageFile,
      {required context}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user != null ? user.uid : '';

      final docRef = _evenementCollection.doc();
      final evenementId = docRef.id;

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Evenements')
          .child(evenementId + '.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      await docRef.set({
        ...evenement.toMap(),
        'id_evenement': evenementId,
        'uid': userId,
        'image': imageUrl,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListeEvenement()),
      );
    } else {
      print("connectez vous pour faire un ajout");
    }
  }

  Stream<List<Evenement>> obtenirTousLesEvenement() {
    return _evenementCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        if (data is Map<String, dynamic>) {
          return Evenement.fromMap(data);
        } else {
          throw FormatException('Données incorrectes pour evènement');
        }
      }).toList();
    });
  }
  Stream<List<Evenement>> obtenirTousMesEvenement(String? _auth)=>FirebaseFirestore.instance.collection('Evenements').where("uid",isEqualTo: _auth).snapshots().map((snapshot) => snapshot.docs.map((doc) =>Evenement.fromMap(doc.data())).toList());





  Stream<List<Evenement>> obtenirtouteslesstories()=>FirebaseFirestore.instance.collection('Evenements').where("story",isEqualTo: true).snapshots().map((snapshot) => snapshot.docs.map((doc) =>Evenement.fromMap(doc.data())).toList());


  Future<void> mettreAJourEvenement(
      Evenement evenement, File? imageFile) async {
    if (imageFile != null) {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Evenements')
          .child(evenement.id_evenement + '.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      Evenement evenementMisAJour = Evenement(
        id_evenement: evenement.id_evenement,
        nom: evenement.nom,
        image: imageUrl,
        coordonnees: evenement.coordonnees,
        region: evenement.region,
        description: evenement.description,
        statut: evenement.statut,
        date_debut: evenement.date_debut,
        date_fin: evenement.date_fin,
      );

      await _evenementCollection
          .doc(evenement.id_evenement)
          .update(evenementMisAJour.toMap());
    } else {
      await _evenementCollection
          .doc(evenement.id_evenement)
          .update(evenement.toMap());
    }
  }

  Future<void> supprimerEvenement(String evenementId) async {
    await _evenementCollection.doc(evenementId).delete();
  }

  Future AjouterStorie(Evenement evenement) async{

    final docPersonne = FirebaseFirestore.instance.collection('Evenements').doc(evenement.id_evenement);

    docPersonne.update({'story':true});
    print("Storie Ajoutée");

  }

  Future RetirerUneStorie(Evenement evenement) async{

    final docPersonne = FirebaseFirestore.instance.collection('Evenements').doc(evenement.id_evenement);

    docPersonne.update({'story':false});

    print("Storie retirée");

  }
}
