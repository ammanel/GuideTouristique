import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Model/logement.dart';
import '../../Repository/logementRepository.dart';

import '../BottomNavBar/Settings.dart';
import 'Ajoutlogement.dart';
import 'detailslogement.dart';
import 'editelogement.dart';
class Meslogements extends StatefulWidget {
  const Meslogements({super.key});

  @override
  State<Meslogements> createState() => _MeslogementsState();
}

class _MeslogementsState extends State<Meslogements> {
  logementRepository lr = new logementRepository();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mes logements"),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<logement>>(
          stream: lr.readAllofMyogement(_auth.currentUser?.uid),
          builder: (context,snapshot){
            List<logement>? meslogements = snapshot.data;
            
            if (snapshot.data !=null) {
              if(meslogements!.isEmpty){
                return Center(
                  child: Text("Aucun logement trouvé"),
                );
              }
            }
            print("Mes logements : $meslogements");
            if(snapshot.data != null || snapshot.hasData) {

              return Container(
                child: ListView.builder(
                  itemCount: meslogements?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                backgroundImage: NetworkImage("${meslogements?[index].image}"),
                              ),
                              subtitle: Text("${meslogements?[index].address}"),
                              title: Text("${meslogements?[index].titre}"),
                              trailing: Container(
                                child: Wrap(
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementEditPage(logment: meslogements![index],)));
                                        },
                                        child: Container(
                                          width: 40,
                                            height: 40,

                                            child: Center(child: Icon(Icons.edit,color: Colors.green,)))),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                        onTap: (){
                                          //Fonction de suppression
                                          print('Supprimé');
                                          lr.deletelogement(meslogements![index]);
                                        },

                                        child: Container(
                                            width: 40,
                                            height: 40,
                                            child: Center(child: Icon(CupertinoIcons.delete,color: Colors.red,))))
                                  ],
                                ),
                              ),
                              style: ListTileStyle.values.last,

                            ),
                          ),
                        ),
                      ),
                    );
                  },

                ),
              );
            }else{
              return Center(
                child: Container(
                    child: CircularProgressIndicator(),
              ),
              );
            }

          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_auth.currentUser != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LogementForm()));
          }else{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Settings()));

          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
