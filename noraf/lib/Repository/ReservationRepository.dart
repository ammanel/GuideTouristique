import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../Model/Reservation.dart';
class ReservationRepository{

readReservation(Reservation reservation) async
{final docReservation = FirebaseFirestore.instance.collection('Reservation').doc(reservation?.uid);
final snapshot = await docReservation.get();if(snapshot.exists){
return Reservation.fromJson(snapshot.data()!);
}}

Stream<List<Reservation>> readAllReservation()=>FirebaseFirestore.instance.collection('Reservation').snapshots().map((snapshot) => snapshot.docs.map((doc) =>Reservation.fromJson(doc.data())).toList());

Stream<List<Reservation>> readAllofmyReservation(String? _auth)=>FirebaseFirestore.instance.collection('Reservation').where("id_client",isEqualTo: _auth).snapshots().map((snapshot) => snapshot.docs.map((doc) =>Reservation.fromJson(doc.data())).toList());


Future UpdateReservation(Reservation Reservation) async{


final docReservation = FirebaseFirestore.instance.collection('Reservation').doc(Reservation.uid);


 docReservation.update({'id_logement' : Reservation.id_logement,'date_arrivee' : Reservation.date_arrivee,'date_depart' : Reservation.date_depart,'nombre_adulte' : Reservation.nombre_adulte,'nombre_enfant' : Reservation.nombre_enfant,});

}


deleteReservation(Reservation Reservation) async {
final docReservation = FirebaseFirestore.instance.collection('Reservation').doc(Reservation.uid);
 docReservation.delete();
}


Future<String?> AjoutReservation(Reservation Reservation) async{
final docReservation = FirebaseFirestore.instance.collection('Reservation').doc();
String path = docReservation.path.split('/')[1];
Reservation.uid = path;
final data = Reservation.toJson();
docReservation.set(data);
return path;
}

}