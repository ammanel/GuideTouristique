import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaiementService{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future CreatePaiment({required String Telephone,required int montant, required String? user_id}) async{
    final docPaiement = FirebaseFirestore.instance.collection("Paiement").doc();
    final docUser = FirebaseFirestore.instance.collection("Users").doc(user_id);
    //final docPost = FirebaseFirestore.instance.collection("Post").doc(_auth.currentUser?.uid);
    String path = docPaiement.path.split("/")[1];
    print(path);

    //*final Paiement paiement = new Paiement(uid: path, idCompte: user_id!, montant: montant, transactionid: user_id+DateTime.now().toString(), date_debut: DateTime.now(), dateFin: DateTime.now().add(new Duration(days: 30)));
    //final Post post = new Post(NomLocation: '',uid: _auth.currentUser?.uid,Pays: "Togo", Quartier: "Hedranawoe", Region: "Maritime", Ville: "Lomé", Description: "Avion", Image_maison: "", Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0, post_id: docPost.id);
    //String path = docPost.path.split("/")[1];
    //print(path);
    //post.post_id = path;

    //*final datapaiement =  paiement.toJson();

    //Tfinal dataPost = post.toJson();



    //*docPaiement.set(datapaiement);
    docUser.update({
     //* "fin_abonnement" : paiement.dateFin,
      "statuspaiment" : true
    });
    //docPost.set(dataPost);
    //await docUser.set(json);
    print("Paiement effectué");
  }

  Future finabonnement() async{

    final docUser = FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser!.uid);
    docUser.update({
      "statuspaiment" : false
    });
  }

  getPaiement() async{
    final docPaiment = FirebaseFirestore.instance.collection("Paiement").doc();
  }
}