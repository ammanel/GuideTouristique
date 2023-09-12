import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


import '../Model/ImageSite.dart';

class ImageSiteRepository {
  final CollectionReference _imageSiteCollection =
      FirebaseFirestore.instance.collection('imageSites');

  Future<void> ajouterimageSite(
      ImageSite imageSite, List<File> imageFiles, String site_id) async {
    final docRef = _imageSiteCollection.doc();
    final imageSiteId = docRef.id;

    for (int i = 0; i < imageFiles.length; i++) {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('imageSites')
          .child(imageSiteId)
          .child('image${i + 1}.jpg');
      final uploadTask = storageRef.putFile(imageFiles[i]);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      await docRef.set({
        ...imageSite.toMap(),
        'id_image_site': imageSiteId,
        'id_site_touristique': site_id,
        'image${i + 1}': imageUrl,
      });
    }
  }
}
