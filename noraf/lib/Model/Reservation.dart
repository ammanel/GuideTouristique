import 'package:cloud_firestore/cloud_firestore.dart';
class Reservation {
 String uid;
 String id_logement;
 DateTime date_arrivee;
 DateTime date_depart;
 int nombre_adulte;
 int nombre_enfant;
 String id_client;
 String TransactionId;

Reservation({required this.TransactionId,required this.id_client,required this.uid,required this.id_logement,required this.date_arrivee,required this.date_depart,required this.nombre_adulte,required this.nombre_enfant,});

Map<String, dynamic> toJson(){
return{
'uid' : uid ,
'id_logement' : id_logement ,
'date_arrivee' : date_arrivee ,
'date_depart' : date_depart ,
'nombre_adulte' : nombre_adulte ,
'nombre_enfant' : nombre_enfant ,
 'id_client' : id_client,
 'TransactionId': TransactionId
};}
static Reservation fromJson(Map<String,dynamic> json) => Reservation(uid: json['uid'],id_logement: json['id_logement'],date_arrivee: (json['date_arrivee'] as Timestamp).toDate(),date_depart: (json['date_depart'] as Timestamp).toDate(),nombre_adulte: json['nombre_adulte'],nombre_enfant: json['nombre_enfant'],id_client: json['id_client'], TransactionId: json['TransactionId']);

}