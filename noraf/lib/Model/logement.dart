import 'package:cloud_firestore/cloud_firestore.dart';
class logement {
 String uid;
 String id_porprietaire;
 String id_logement;
 String image;
 String description;
 String titre;
 String address;
 String prix;
 String region;
 String options;
 String coordonnees;
 String statut;
logement({required this.id_porprietaire,required this.uid,required this.id_logement,required this.image,required this.description,required this.titre,required this.address,required this.prix,required this.region,required this.options,required this.coordonnees,required this.statut,});

Map<String, dynamic> toJson(){
return{
'uid' : uid ,
'id_logement' : id_logement ,
'image' : image ,
'description' : description ,
'titre' : titre ,
'address' : address ,
'prix' : prix ,
'region' : region ,
'options' : options ,
'coordonnees' : coordonnees ,
'statut' : statut ,
 'id_porprietaire': id_porprietaire
};}
static logement fromJson(Map<String,dynamic> json) => logement(uid: json['uid'],id_logement: json['id_logement'],image: json['image'],description: json['description'],titre: json['titre'],address: json['address'],prix: json['prix'],region: json['region'],options: json['options'],coordonnees: json['coordonnees'],statut: json['statut'], id_porprietaire: json['id_porprietaire'],);

}