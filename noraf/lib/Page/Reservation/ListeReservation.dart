import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

import '../../Model/Reservation.dart';
import '../../Repository/ReservationRepository.dart';
import '../../Repository/logementRepository.dart';
import '../BottomNavBar/Settings.dart';
import '../utils/CustumText.dart';
import 'detailsReservation.dart';

class listeReservation extends StatelessWidget {
  const listeReservation({super.key});

  @override
  Widget build(BuildContext context) {
    ReservationRepository reservationRepository = new ReservationRepository();
    logementRepository lr = new logementRepository();
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("R E S E R V A T I O N S"),
        elevation: 0,
        centerTitle: true,
      ),
      body: _auth.currentUser!=null?StreamBuilder<List<Reservation>>(
          stream: reservationRepository.readAllReservation(),
          builder: (context,snapshot){
                List<Reservation>? suggestions = [];
                suggestions = snapshot.data?.where((searcheResult){
                final result = searcheResult.id_client;
                final input = _auth.currentUser!.uid;
                return result.contains(input);

                }).toList();
                if(snapshot.hasError){
                  return Center(child: Text("Une erreur est survenue"),);
                }else {
                  if(snapshot.hasData) {
                    if (suggestions != null && suggestions.isEmpty) {
                      return Center(
                        child: Text("Aucune réservation trouvée"),
                      );
                    } else {
                      return Center(
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.15,
                          child: Column(
                            children: [
                              Column(
                                children: [],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: suggestions?.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.hasError) {
                                      print(
                                          "L'erreur est la suivante : ${snapshot
                                              .error}");
                                    } else {
                                      if (snapshot.hasData) {
                                        return GestureDetector(
                                            onTap: () {
                                              print("Touché");
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          detailReservation(
                                                              reservation: suggestions![index])));
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 150,

                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        8.0),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    CustumText(
                                                                        "Reservation",
                                                                        Colors
                                                                            .black,
                                                                        "Acme",
                                                                        25),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text(
                                                                      "Transaction_${snapshot
                                                                          .data?[index]
                                                                          .TransactionId}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 20,
                                                                          fontFamily: "Acme"),)
                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          Row()
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10,)
                                              ],
                                            )
                                        );
                                      }
                                    }
                                  },

                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    }
                  }else{
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.grey[200],height: 100,width: MediaQuery.of(context).size.width/1.2,
                            ),

                          ],
                        ),
                      ),
                    );
                  }
                }

          }
      ):Settings(),
    );
  }
}
