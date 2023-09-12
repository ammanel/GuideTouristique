import 'package:cloud_firestore/cloud_firestore.dart';

class Paiement{
  String uid;
  String idCompte;
  String transactionid;
  int montant;
  DateTime date_debut;
  DateTime dateFin;


  Paiement({required this.date_debut,required this.dateFin,required this.uid,required this.idCompte, required this.montant, required this.transactionid});

  Map<String, dynamic> toJson(){
    return {
      "uid" : uid,
      "idCompte" : idCompte,
      "transactionid" : transactionid,
      "montant" : montant,
      "date_debut" : date_debut,
      "date_fin": dateFin,
    };
  }


  static Paiement fromJson(Map<String,dynamic> json) => Paiement(uid: json["uid"], idCompte: json["idCompte"], montant: json["montant"], transactionid: json["transactionid"], date_debut: (json["date_debut"] as Timestamp).toDate(), dateFin: (json["date_fin"] as Timestamp).toDate());

}