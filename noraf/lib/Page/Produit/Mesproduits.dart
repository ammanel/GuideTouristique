import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';


import '../../Model/Produit.dart';
import '../../Repository/produit_repository.dart';
import 'PageListeProduit.dart';
import 'Produit.dart';
import 'detailsproduits.dart';
class Mesproduits extends StatefulWidget {
  const Mesproduits({super.key});

  @override
  State<Mesproduits> createState() => _MesproduitsState();
}

class _MesproduitsState extends State<Mesproduits> {
  @override
  Widget build(BuildContext context) {
    List<Produit> suggestions = [];
    FirebaseAuth _auth = FirebaseAuth.instance;
    ProduitRepository _produitRepository = new ProduitRepository();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("P R O D U I T S"),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Produit>>(
        stream: _produitRepository.obtenirTousLesProduits(),
          builder: (context,snapshot){
          if(snapshot.hasData){
          searchResult = snapshot.data!;
          suggestions = searchResult.where((searcheResult){
          final result = searcheResult.utilisateurId.toLowerCase();
          final input = "${_auth.currentUser!.uid}".toLowerCase();
          print(_auth.currentUser!.uid);
          return result.contains(input);

          }).toList();
    if(suggestions.isEmpty){
    print("Vide");
    return Center(
    child: Text("Aucun produit trouvé"),
    );
    }
    }else{
    print("Aucun résultat trouvé");
    }
    return Container(
    child: ListView.builder(
    itemCount: suggestions?.length,
    itemBuilder: (context,index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[100],

        child: Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 10),
          child: ListTile(
            leading: suggestions[index].type =="agro-alimentaire"?Icon(Icons.fastfood_rounded):Icon(Icons.electrical_services_rounded),
            title: Text("${suggestions[index].nom}"),
            subtitle: Text("${suggestions[index].description}"),
            trailing: Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProduitPage(produit: suggestions[index])));
                      },
                      child: Icon(Icons.edit,color: Colors.green,)),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(CupertinoIcons.delete,color: Colors.red,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
    },

    ),
    );

    }
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProduitPage(produit: Produit(id: "", image: "", nom: "", prix: 0, coordonneevendeur: "", description: "", type: "", utilisateurId: ""))));
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
