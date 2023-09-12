import 'package:cloud_firestore/cloud_firestore.dart';
class PaiementReservation {
 String uid;
 String CompteId;
 String TransactionId;
 double Montant;
PaiementReservation({required this.uid,required this.CompteId,required this.TransactionId,required this.Montant,});

Map<String, dynamic> toJson(){
return{
'uid' : uid ,
'CompteId' : CompteId ,
'TransactionId' : TransactionId ,
'Montant' : Montant ,
};}
static PaiementReservation fromJson(Map<String,dynamic> json) => PaiementReservation(uid: json['uid'],CompteId: json['CompteId'],TransactionId: json['TransactionId'],Montant: json['Montant'],);

}