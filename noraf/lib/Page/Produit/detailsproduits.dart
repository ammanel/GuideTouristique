import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../Model/Produit.dart';
import '../utils/CustumText.dart';
import 'package:url_launcher/url_launcher.dart';

class detailsproduit extends StatelessWidget {
  final Produit produit;

  detailsproduit({required this.produit});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
            height: MediaQuery.of(context).size.height,

            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: "${produit.image}",
                  imageBuilder: (context,imageprovider){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            image:
                            imageprovider,fit: BoxFit.cover),
                      ),

                      //Propriétés de l'image
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2,
                    );
                  },
                  placeholder: (context,url) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),

                    //Propriétés de l'image
                    width: MediaQuery.of(context).size.width/3,
                    height: 160,

                  ).asGlass(),
                ),
                Expanded(child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Image

                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Container(

                            child: Column(
                              children: [
                                //Nom du logement et le rate
                                Row(
                                  children: [
                                    CustumText("${produit.nom}", Colors.black, "Acme", 25),
                                    Expanded(child: Container()),
                                    Icon(Icons.star,size: 20,color: Colors.lightBlue,),
                                    Text("4.8",style: TextStyle(color: Colors.grey[500]),)
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //position
                                Row(
                                  children: [
                                    Icon(Icons.location_on,color: Colors.lightBlue),
                                    CustumText("${produit.type}", Colors.grey, "Acme", 20),
                                    Expanded(child: Container()),

                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //Description
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.2,
                                      child: Text("${produit.description}",style: TextStyle(color: Colors.grey,fontFamily: "Acme"),),
                                    )

                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //Coordonnées vendeurs
                                Row(
                                  children: [
                                    Text("Vendeur : ",style: TextStyle(fontFamily: "Acme"),),
                                    Icon(CupertinoIcons.phone),
                                    Text("${produit.coordonneevendeur}")
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),


                              ],

                            ),

                          ),
                        )

                      ],
                    ),
                  ),

                )),

                Container(

                  height: 80,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${produit.prix} FCFA",style: TextStyle(fontFamily: "Acme",fontSize: 20),),

                        TextButton(onPressed: (){

                          final Uri _phonenumber = Uri.parse('tel:+228${this.produit.coordonneevendeur}');
                          final Uri Whatsapp = Uri.parse("https://wa.me/+22891281270");
                          launchUrl(Whatsapp,mode: LaunchMode.externalApplication);
                        }, child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlue,
                          ),

                          width: MediaQuery.of(context).size.width/2,
                          child: Center(child: CustumText("Contacter", Colors.white, "Acme", 25)),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            )

        ),

      ),
    );
  }
}
