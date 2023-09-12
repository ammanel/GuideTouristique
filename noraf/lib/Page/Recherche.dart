import 'dart:async';

import 'package:derniernoraf/Page/utils/CustumText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/logement.dart';
import '../Repository/PersonneRepository.dart';
import '../Repository/logementRepository.dart';
import 'logement/detailslogement.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  TextEditingController _textEditingController = TextEditingController();
  PersonneRepository pr= new PersonneRepository();
  logementRepository lr = new logementRepository();
  String searchQuery = '';
  List<logement> people = [];
  List<logement> logementv = [];

  List<logement> searchResult = [

  ];

  @override
  Widget buildSuggestions(BuildContext context){
    List<logement> suggestions = [];
    return StreamBuilder<List<logement>>(
        stream: lr.readAlllogement(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            searchResult = snapshot.data!;
            suggestions = searchResult.where((searcheResult){
                final result = searcheResult.region.toLowerCase();
                final input = searchQuery.toLowerCase();
                return result.contains(input);

            }).toList();
            if(suggestions.isEmpty){
              searchResult = snapshot.data!;
              suggestions = searchResult.where((searcheResult){
                final result = searcheResult.address.toLowerCase();
                final input = searchQuery.toLowerCase();
                return result.contains(input);

              }).toList();
            }
            if(suggestions.isEmpty){
              searchResult = snapshot.data!;
              suggestions = searchResult.where((searcheResult){
                final result = searcheResult.titre.toLowerCase();
                final input = searchQuery.toLowerCase();
                return result.contains(input);

              }).toList();
            }
            print(suggestions);
            if(suggestions.isEmpty){
              print("Bawin");
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
              return GestureDetector(
                onTap: (){
                  print("Touché");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: suggestions[index])));
                },
                child: ListTile(
                  leading: Icon(CupertinoIcons.location_solid,color: Colors.black,),
                  subtitle: Text("${suggestions[index].address}"),
                  title: Text("${suggestions[index].titre}"),
                  

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


    /*
    const duration = Duration(seconds: 1);
    Timer(duration, () {
      List<logement> searchResults = lr.searchPeople(people, searchQuery);
      if (searchResults.isNotEmpty) {

        for (logement log in searchResults) {

          setState(() {

            people = searchResults;
            logementv = searchResults;

          });
        }
      } else {


      }

    });

    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color(0xff1195d5),
        title: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Entrer votre recherche',
            // Ajoutez ici d'autres propriétés de décoration si nécessaire
          ),
          onChanged: (value) {
            // Vous pouvez effectuer des actions lorsque le texte change

            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,

        child: FutureBuilder(future: pr.readOnlineUser(),
            builder: (context,snapshot){
              return StreamBuilder<List<logement>>(
                stream: lr.readAlllogement(),
                builder: (context,snapshot){
                  if(snapshot.hasError){
                    print(snapshot.error);
                    return Center(child: Text("Une erreur s'est produite...",));
                  }
                  else if(snapshot.hasData){
                    final logements = snapshot.data!;
                    people = logements;
                    return logements == null ? Center(child: Text("Aucun enregistrement trouvé"),) : searchQuery==""?ListView.builder(
                      itemCount: logements.length,
                      itemBuilder: (BuildContext context, int index) {

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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      image: DecorationImage(image: NetworkImage(logements[index].image),fit: BoxFit.cover),
                                    ),
                                    width: MediaQuery.of(context).size.width/1.2,
                                    height: 140,
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
                                                  child: Text("${logements[index].titre}",style: TextStyle(fontSize: 15),)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.star,color: Color(0xff55ba5b),size: 15,),
                                              Icon(Icons.star,color: Color(0xff55ba5b),size: 15),
                                              Icon(Icons.star,color: Color(0xff55ba5b),size: 15),
                                              Icon(Icons.star,color: Color(0xff55ba5b),size: 15),
                                              Icon(Icons.star,color: Color(0xff55ba5b),size: 15),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("[200 viewers]")

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
                                child: Icon(CupertinoIcons.heart_fill,color: Color(0xff55ba5b),),
                              )),

                          ],
                        ),
                                onTap: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: logements[index])));

                                },
                              )
                            ],
                          ),
                        );
                      },

                    ) :

                    ListView.builder(
                      itemCount: logementv.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(logementv.length == 0) {
                          print("vide");
                          return Text("vide");
                        }else{
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))
                                        ),
                                        child: Column(
                                          children: [
                                            Card(

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15))
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          logementv[index].image),
                                                      fit: BoxFit.cover),
                                                ),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width / 1.2,
                                                height: 140,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Wrap(
                                                        children: [
                                                          Container(
                                                              width: 200,
                                                              child: Text(
                                                                "${logementv[index]
                                                                    .titre}",
                                                                style: TextStyle(
                                                                    fontSize: 15),)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.star,
                                                            color: Color(0xff55ba5b),
                                                            size: 15,),
                                                          Icon(Icons.star,
                                                              color: Color(0xff55ba5b),
                                                              size: 15),
                                                          Icon(Icons.star,
                                                              color: Color(0xff55ba5b),
                                                              size: 15),
                                                          Icon(Icons.star,
                                                              color: Color(0xff55ba5b),
                                                              size: 15),
                                                          Icon(Icons.star,
                                                              color: Color(0xff55ba5b),
                                                              size: 15),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("[200 viewers]")

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
                                            child: Icon(CupertinoIcons.heart_fill,
                                              color: Color(0xff55ba5b),),
                                          )),

                                    ],
                                  ),
                                  onTap: () {
                                    print("Touché container numero : " +
                                        index.toString());
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: logementv[index])));
                                  },
                                )
                              ],
                            ),
                          );
                                    }
                      }
                    );
                  }
                  else{

                      return Center(child: Text("Rien à afficher"),);
                  }
                },
              );

            }),
      )
    );*/

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5)
            ),

            hintText: "Rechercher un logement...",
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,


          ),
          onChanged: (value) {
            // Vous pouvez effectuer des actions lorsque le texte change

            setState(() {
              searchQuery = value;
            });
          },
        ),
        centerTitle: false,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(onPressed: (){
                    setState(() {
                      searchQuery = "";
                    });
                  }, child:
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 70,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Tout", Colors.black, "", 15),
                      )))),
                  TextButton(onPressed: (){
                    setState(() {
                      searchQuery = "Savane";
                    });
                  }, child:
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                      width: 100,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Dapaong", Colors.black, "", 15),
                      )))),
                  TextButton(onPressed: (){
                    setState(() {
                      searchQuery = "kara";
                    });

                  }, child:
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 100,

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Kara", Colors.black, "", 15),
                      )))),
                  TextButton(onPressed: (){
                    setState(() {
                      searchQuery = "Centrale";
                    });
                  }, child:
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 100,

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Sokode", Colors.black, "", 15),
                      )))),
                  TextButton(onPressed: (){
                    setState(() {
                      searchQuery = "plateaux";
                    });
                  }, child:
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 110,

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Atapkame", Colors.black, "", 15),
                      )))),
                  TextButton(onPressed: (){

                    setState(() {
                      searchQuery = "maritime";
                    });

                  }, child:
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: 100,

                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustumText("Tsévié", Colors.black, "", 15),
                      )))),

                ],
              ),
            ),
            Expanded(child: buildSuggestions(context))
          ],
        ),
      ),
    );
  }
}
