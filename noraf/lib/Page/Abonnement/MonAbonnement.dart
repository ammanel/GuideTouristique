import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

import 'Cinetpay.dart';


class MonAbonnement extends StatelessWidget {
  const MonAbonnement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("A B O N N E M E N T",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            //pack de 1 mois
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp(montant: '200',)));
              },
              child: Container(
                    width: MediaQuery.of(context).size.width/1.2,

                    height: MediaQuery.of(context).size.height/2.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("1 Mois",style: TextStyle(fontSize: 20,color: Colors.white),),
                      Text("5000 XOF",style: TextStyle(fontSize: 30,color: Colors.red,fontWeight: FontWeight.bold),),
                      Container(
                        width: MediaQuery.of(context).size.width/1.29,
                          child:
                              Center(child: Text("Vous aurez accès aux différantes fonctionnaltés de la plateforme",style: TextStyle(color: Colors.white),)),
                            ),
                    ],
                  ),
                  ).asGlass(
                  clipBorderRadius: BorderRadius.circular(15.0)
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //Pack de 3 mois
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp(montant: '13500',)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width/1.2,

                height: MediaQuery.of(context).size.height/2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("3 Mois",style: TextStyle(fontSize: 20,color: Colors.white),),
                    Text("13500 XOF",style: TextStyle(fontSize: 30,color: Colors.red,fontWeight: FontWeight.bold),),
                    Text("Vous économisez une somme de 1500 XOF",style: TextStyle(color: Colors.white),),
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                        child: Text("Vous aurez accès aux différantes fonctionnaltés de la plateforme et vos évènements seront mis en story àfin de les rendres plus visbile",style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ).asGlass(
                  clipBorderRadius: BorderRadius.circular(15.0)
              ),
            ),

          ],
        ),
      ),
    );
  }
}
