import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

import '../../Model/Produit.dart';
import '../../Repository/produit_repository.dart';
import 'Produit.dart';
import 'detailsproduits.dart';

class PageListeProduit extends StatefulWidget {

  @override
  State<PageListeProduit> createState() => _PageListeProduitState();
}
  List<Produit> searchResult = [

  ];
  String searchQuery = '';
  @override

  class _PageListeProduitState extends State<PageListeProduit>{
    final ProduitRepository _produitRepository = ProduitRepository();
    Widget buildSuggestions(BuildContext context){
      List<Produit> suggestions = [];
      return StreamBuilder<List<Produit>>(
          stream: _produitRepository.obtenirTousLesProduits(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              searchResult = snapshot.data!;
              suggestions = searchResult.where((searcheResult){
                final result = searcheResult.type.toLowerCase();
                final input = searchQuery.toLowerCase();
                return result.contains(input);

              }).toList();
              if(suggestions.isEmpty){
                print("Vide");
                return Center(
                  child: Text("Aucun résultat trouvé"),
                );
              }
            }else{
              print("Aucun résultat trouvé");
            }
            return Container(
              child: ListView.builder(
                itemCount: suggestions?.length,
                itemBuilder: (context,index){
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Stack(
                            children: [
                              Card(
                                elevation: 1,
                                shadowColor: Colors.black,

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                ),
                                child: Column(
                                  children: [
                                    Card(

                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: "${suggestions[index].image}",
                                        imageBuilder: (context,imageprovider){
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                              image: DecorationImage(
                                                  image:
                                                  imageprovider,fit: BoxFit.cover),
                                            ),

                                            //Propriétés de l'image
                                            width: MediaQuery.of(context).size.width/1.2,
                                            height: 140,
                                          );
                                        },
                                        placeholder: (context,url) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                          ),

                                          //Propriétés de l'image
                                          width: MediaQuery.of(context).size.width/1.2,
                                          height: 160,

                                        ).asGlass(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      child: Text("${suggestions[index].nom}",style: TextStyle(fontSize: 15),)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.star,color: Colors.red,size: 15,),
                                                  Icon(Icons.star,color: Colors.red,size: 15,),
                                                  Icon(Icons.star,color: Colors.red,size: 15,),
                                                  Icon(Icons.star,color: Colors.red,size: 15,),
                                                  Icon(Icons.star,color: Colors.red,size: 15,),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("${suggestions[index].prix} Fcfa")

                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              Positioned(
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        child: Icon(CupertinoIcons.heart_fill,color: Colors.red,).asGlass(
                                          clipBorderRadius: BorderRadius.circular(8.0),
                                        )),
                                  )),

                            ],
                          ),
                          onTap: (){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> detailsproduit(produit: suggestions[index])));

                          },
                        )
                      ],
                    ),
                  );
                },

              ),
            );

          }
      );

    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Column(
          children: [
            Row(
              children: [

                TextButton(onPressed:(){
                  setState(() {
                    searchQuery = "";
                  });
                }, child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Tout",style: TextStyle(color: Colors.black),),
                    ),
                  ),
                )),
                TextButton(onPressed:(){
                  setState(() {
                    searchQuery = "artisanaux";
                  });
                }, child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Agro-alimentaire",style: TextStyle(color: Colors.black),),
                    ),
                  ),
                )),

                TextButton(onPressed:(){
                  setState(() {
                    searchQuery = "agro-alimentaire";
                  });
                }, child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Artisanaux",style: TextStyle(color: Colors.black),),
                    ),
                  ),
                )),

              ],
            ),
            Expanded(child: buildSuggestions(context))

          ],
        ),
      );
    }
  }

