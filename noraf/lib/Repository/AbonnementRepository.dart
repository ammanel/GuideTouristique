import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as Path;

import '../Model/Abonnement.dart';
import '../Page/Acceuil.dart';
import 'PersonneRepository.dart';
class AbonnementRepository{

readAbonnement(Abonnement abonnement) async
{final docAbonnement = FirebaseFirestore.instance.collection('Abonnement').doc(abonnement?.uid);
final snapshot = await docAbonnement.get();if(snapshot.exists){
return Abonnement.fromJson(snapshot.data()!);
}}

Stream<List<Abonnement>> readAllAbonnement()=>FirebaseFirestore.instance.collection('Abonnement').snapshots().map((snapshot) => snapshot.docs.map((doc) =>Abonnement.fromJson(doc.data())).toList());


Future UpdateAbonnement(Abonnement Abonnement) async{


final docAbonnement = FirebaseFirestore.instance.collection('Abonnement').doc(Abonnement.uid);


 docAbonnement.update({'IdCompte' : Abonnement.IdCompte,'TransactionId' : Abonnement.TransactionId,'Montant' : Abonnement.Montant,'dateDebut' : Abonnement.dateDebut,'dateFin' : Abonnement.dateFin,});

}


deleteAbonnement(Abonnement Abonnement) async {
final docAbonnement = FirebaseFirestore.instance.collection('Abonnement').doc(Abonnement.uid);
 docAbonnement.delete();
}


Future<String?> AjoutAbonnement(Abonnement Abonnement,context) async{
final docAbonnement = FirebaseFirestore.instance.collection('Abonnement').doc();
String path = docAbonnement.path.split('/')[1];
Abonnement.uid = path;
PersonneRepository pr = new PersonneRepository();
pr.AbonnementEffectuee(Abonnement.IdCompte,Abonnement.dateFin);
final data = Abonnement.toJson();
showDialog(context: context, builder: (builder){
 return Center(
  child: CircularProgressIndicator(),
 );
});

docAbonnement.set(data);

Navigator.pop(context);

Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
return path;
}

}