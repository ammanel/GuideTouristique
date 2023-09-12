import 'package:cloud_firestore/cloud_firestore.dart';
class Abonnement {
 String uid;
 String IdCompte;
 String TransactionId;
 double Montant;
 DateTime dateDebut;
 DateTime dateFin;
Abonnement({required this.uid,required this.IdCompte,required this.TransactionId,required this.Montant,required this.dateDebut,required this.dateFin,});

Map<String, dynamic> toJson(){
return{
'uid' : uid ,
'IdCompte' : IdCompte ,
'TransactionId' : TransactionId ,
'Montant' : Montant ,
'dateDebut' : dateDebut ,
'dateFin' : dateFin ,
};}
static Abonnement fromJson(Map<String,dynamic> json) => Abonnement(uid: json['uid'],IdCompte: json['IdCompte'],TransactionId: json['TransactionId'],Montant: json['Montant'],dateDebut: (json['dateDebut'] as Timestamp).toDate(),dateFin: (json['dateFin'] as Timestamp).toDate(),);

}