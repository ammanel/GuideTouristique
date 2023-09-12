import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Model/Reservation.dart';
import '../utils/CustumText.dart';
class detailReservation extends StatelessWidget {
  final Reservation reservation;

  detailReservation({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details de votre réservation"),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width-50,
          height: MediaQuery.of(context).size.height/1.7,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0,3)
              )],
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 10,
              ),
              Text("Ma reservation",style: TextStyle(fontSize: 20),),

              QrImageView(
                data: "Res_${reservation.TransactionId}",
                version: QrVersions.auto,
                size: 200.0,
              ),
              CustumText("Réservation", Colors.black, "Acme", 25),
              CustumText("Ticket", Colors.black, "Acme", 15),

              SizedBox(
                height: 10,
              ),
              CustumText("Code du Ticket", Colors.black, "Acme", 18),
              SizedBox(
                height:5,
              ),
              Container(
                height: 2,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 20,
              ),

              CustumText("Res_${reservation.TransactionId}", Colors.red, "Acme", 28),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 2,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustumText("Arrivee", Colors.green, "Acme", 18),
                        Text(DateFormat.MMMMEEEEd().format(reservation.date_arrivee),style: TextStyle(fontFamily: "Acme"),)
                      ],
                    ),
                  ),
                  SizedBox(),
                  SizedBox(),
                  SizedBox(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustumText("Départ", Colors.red, "Acme", 18),
                        Text(DateFormat.MMMMEEEEd().format(reservation.date_depart),style: TextStyle(fontFamily: "Acme"),)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(),
              SizedBox(),
              SizedBox(),

              CustumText("Conçus par NORAF technologie", Colors.grey, "fontfamity", 12)
            ],
          ),
        ),
      )),
    );
  }
}
