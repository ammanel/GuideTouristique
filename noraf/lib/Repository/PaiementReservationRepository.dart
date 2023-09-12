import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../Model/PaiementReservation.dart';
class PaiementReservationRepository{

readPaiementReservation(PaiementReservation paiementreservation) async
{final docPaiementReservation = FirebaseFirestore.instance.collection('PaiementReservation').doc(paiementreservation?.uid);
final snapshot = await docPaiementReservation.get();if(snapshot.exists){
return PaiementReservation.fromJson(snapshot.data()!);
}}

Stream<List<PaiementReservation>> readAllPaiementReservation()=>FirebaseFirestore.instance.collection('PaiementReservation').snapshots().map((snapshot) => snapshot.docs.map((doc) =>PaiementReservation.fromJson(doc.data())).toList());


Future UpdatePaiementReservation(PaiementReservation PaiementReservation) async{


final docPaiementReservation = FirebaseFirestore.instance.collection('PaiementReservation').doc(PaiementReservation.uid);


 docPaiementReservation.update({'CompteId' : PaiementReservation.CompteId,'TransactionId' : PaiementReservation.TransactionId,'Montant' : PaiementReservation.Montant,});

}


deletePaiementReservation(PaiementReservation PaiementReservation) async {
final docPaiementReservation = FirebaseFirestore.instance.collection('PaiementReservation').doc(PaiementReservation.uid);
 docPaiementReservation.delete();
}


Future<String?> AjoutPaiementReservation(PaiementReservation PaiementReservation) async{
final docPaiementReservation = FirebaseFirestore.instance.collection('PaiementReservation').doc();
String path = docPaiementReservation.path.split('/')[1];
PaiementReservation.uid = path;
final data = PaiementReservation.toJson();
docPaiementReservation.set(data);
return path;
}

}