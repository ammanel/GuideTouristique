import 'dart:async';
import 'dart:math';
import 'package:cinetpay/cinetpay.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/Reservation.dart';
import '../../Repository/AbonnementRepository.dart';
import '../../Repository/PaiementReservationRepository.dart';
import '../../Repository/ReservationRepository.dart';




class MyApp extends StatefulWidget {
  final Reservation reservation;

  MyApp({required this.reservation});
  @override
  _MyAppState createState() => new _MyAppState();
}



class _MyAppState extends State<MyApp> {
  TextEditingController amountController = new TextEditingController();
  Map<String, dynamic>? response;
  Color? color;
  IconData? icon;
  bool show = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AbonnementRepository _abonnementRepository = new AbonnementRepository();
  PaiementReservationRepository _paiementReservationRepository = new PaiementReservationRepository();
  ReservationRepository _reservationRepository = new ReservationRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = 'Payement Reservation';
    return GetMaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          show ? Icon(icon, color: color, size: 150) : Container(),
                          show ? SizedBox(height: 50.0) : Container(),
                          SizedBox(height: 50.0),
                          SizedBox(height: 50.0),
                          SizedBox(height: 40.0),
                          ElevatedButton(
                            child: Text("Payer"),
                            onPressed: () async {
                              String amount = "200";
                              if(amount.isEmpty) {
                                // Mettre une alerte
                                return;
                              }
                              double _amount = double.tryParse(amount) as double;
                              try {
                                _amount = double.parse(amount);

                                if (_amount < 100) {
                                  // Mettre une alerte
                                  return;
                                }

                                if (_amount > 1500000) {
                                  // Mettre une alerte
                                  return;
                                }
                              }

                              catch (exception) {
                                return;
                              }

                              amountController.clear();

                              final String transactionId0 = Random().nextInt(100000000).toString(); // Mettre en place un endpoint à contacter cêté serveur pour générer des ID unique dans votre BD

                              await Get.to(CinetPayCheckout(
                                title: 'Payment Checkout',
                                titleStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                ),
                                titleBackgroundColor: Colors.green,
                                configData: <String, dynamic> {
                                  'apikey': '66623283664389d2a61b6a6.75178443',
                                  'site_id': 958655,
                                  'notify_url': 'https://github.com/ammanel/Auto-ecole-en-ligne'
                                },
                                paymentData: <String, dynamic> {
                                  'transaction_id': transactionId0,
                                  'amount': _amount,
                                  'currency': 'XOF',
                                  'channels': 'ALL',
                                  'description': 'Test de paiement',
                                },
                                waitResponse: (data) {
                                  if (mounted) {
                                    setState(() {
                                      response = data;
                                      print(response);
                                      icon = data['status'] == 'ACCEPTED' ? Icons.check_circle : Icons.mood_bad_rounded;
                                      color = data['status'] == 'ACCEPTED' ? Colors.green : Colors.redAccent;
                                      if(data['status'] == "ACCEPTED"){
                                        _reservationRepository.AjoutReservation(this.widget.reservation);
                                        ElegantNotification.success(
                                          title:  Text("Réservation Effectuée"),
                                          description:  Text("Votre reservation à bien été effectuée avec succes"),
                                          //animationDuration: Duration(milliseconds: 5),
                                        ).show(context);
                                      }
                                      show = true;
                                      Get.back();
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> Splashscreen()));

                                    });
                                  }
                                },
                                onError: (data) {
                                  if (mounted) {
                                    setState(() {
                                      response = data;
                                      print("Erreur : "+response.toString());
                                      icon = Icons.warning_rounded;
                                      color = Colors.yellowAccent;
                                      show = true;
                                      Get.back();
                                    });
                                  }
                                },
                              ));
                            },
                          ),
                          ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Retour"))
                        ],
                      ),
                    ],
                  )
              )
          )
      ),
    );
  }
}