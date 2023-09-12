import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashtoast/flash_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/PaiementReservation.dart';
import '../../Model/Reservation.dart';
import '../../Model/logement.dart';
import '../../Repository/AbonnementRepository.dart';

import '../../Repository/PaiementReservationRepository.dart';
import '../../Repository/ReservationRepository.dart';
import '../Acceuil.dart';
import '../utils/CustumText.dart';
import 'PaiementReservation.dart';

class ReservationForm extends StatefulWidget {
  final logement log ;

  ReservationForm({required this.log});
  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final GlobalKey webViewKey = GlobalKey();
  final Uri wave = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.wave.personal");
  final _formKey = GlobalKey<FormState>();
  double montanpaiement = 200;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions());
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reservation _reservation = Reservation(date_arrivee: DateTime.now(),date_depart: DateTime.now(),id_logement: "",nombre_adulte: 0,nombre_enfant: 0,uid: "", id_client: '', TransactionId: '');
  DateTime _dateArrivee = DateTime.now();
  DateTime _dateDepart = DateTime.now();
  int nombread = 0;
  int nombrekid = 0;
  DateTimeRange selectedDate = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  int etapecourante = 0;
  TextEditingController amountController = new TextEditingController();
  Map<String, dynamic>? response;
  Color? color;
  IconData? icon;
  bool show = false;
  AbonnementRepository _abonnementRepository = new AbonnementRepository();
  PaiementReservationRepository _paiementReservationRepository = new PaiementReservationRepository();
  ReservationRepository _reservationRepository = new ReservationRepository();
  Reservation objetfinalReservation = new Reservation(id_client: "", uid: "", id_logement: "", date_arrivee: DateTime.now(), date_depart: DateTime.now(), nombre_adulte: 0, nombre_enfant: 0, TransactionId: '');

  List<Step> getSteps() =>[
    Step(state: etapecourante >0 ? StepState.complete : StepState.indexed,title: Text("Durée"), content: Container(
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.5),

                blurRadius: 5,
                offset: Offset(0,3)

            )],
            borderRadius: BorderRadius.circular(10),

            color: Colors.grey[100]
        ),
        child: Form(
        key: _formKey, child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [

              CustumText("Combien de temps allez vous faire chez nous ?", Colors.black, "", 18),
              Row(
                children: [
                  TextButton(onPressed: ()async{
                    final DateTimeRange? datetimarange = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
                    if(datetimarange!= null){
                      setState(() {
                        selectedDate = datetimarange;
                      });
                    }
                  }, child: Icon(Icons.date_range)),
                  Expanded(

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ce champ est onligatoire';
                        }else{
                          print(value);
                        }
                        return null;
                      },
                      decoration: InputDecoration(

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5)
                        ),

                        label: selectedDate.duration.inDays!=0?Text("${selectedDate.duration.inDays} jours") : Text("Veiller sélectionner une durée.."),
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabled: false

                      ),
                    ),
                  )
                ],
              ),


            ],

            ),
        ),
        ),
      )
    ),isActive: etapecourante >= 0),
    Step(state: etapecourante >1 ? StepState.complete : StepState.indexed,title: Text("Nombre de personnes attendues"), content: Container(
      child: Column(
        children: [
          Row(
            children: [
              Text("Combien êtes vous?",style: TextStyle(fontSize: 20),),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.5),

                        blurRadius: 5,
                        offset: Offset(0,3)
                        
                    )],
                    borderRadius: BorderRadius.circular(10),

                    color: Colors.grey[100]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Adultes : "),
                                CustumText("13 ans et plus", Colors.black, "fontfamity", 10)
                              ],
                            ),
                          ),

                          Container(
                            child: Row(
                              children: [

                                InkWell(
                                    onTap: (){
                                      if(nombread > 0 ){
                                        setState(() {
                                          nombread--;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.add_box_rounded,size: 40,)),
                                Text("${nombread}",style: TextStyle(fontSize: 20)),
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        nombread++;
                                      });
                                    },
                                    child: Icon(Icons.add_box_rounded,size: 40,))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Enfants : "),
                                CustumText("12 ans et moinss", Colors.black, "fontfamity", 10)
                              ],
                            ),
                          ),

                          Container(
                            child: Row(
                              children: [

                                InkWell(
                                    onTap: (){
                                      if(nombrekid > 0 ){
                                        setState(() {
                                          nombrekid--;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.add_box_rounded,size: 40,)),
                                Text("${nombrekid}",style: TextStyle(fontSize: 20),),
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        nombrekid++;
                                      });
                                    },
                                    child: Icon(Icons.add_box_rounded,size: 40,))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

          SizedBox(height: 16.0),



        ],
      ),
    ),isActive: etapecourante >= 1),
    Step(state: etapecourante >2 ? StepState.complete : StepState.indexed,title: Text("Paiement"), content: Container(
      child: Column(
        children: [
          SafeArea(
                    child: Center(
                        child: Text("Appuyer sur continuer pour valider et procéder au paiment"),
                    )
                ),
        ],
      )

    ),isActive: etapecourante >= 2),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    objetfinalReservation.id_client = _auth.currentUser!.uid;
    objetfinalReservation.id_logement = this.widget.log.id_logement;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation'),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Colors.red)
        ),
        child: Stepper(
          steps: getSteps(),
          currentStep: etapecourante,
          onStepContinue: (){

            if(etapecourante ==0) {
              if (selectedDate.duration.inDays != 0) {
                if (etapecourante < 2) {
                  setState(() {
                    objetfinalReservation.date_arrivee = selectedDate.start;
                    objetfinalReservation.date_depart = selectedDate.end;
                    etapecourante += 1;
                  });
                }
              }else{
                FlashToast.showFlashToast(context: context, title: "Erreur", message: "Veillez préciser le temps que vous allez faire chez nous ", flashType: FlashType.warning,flashPosition: FlashPosition.top);
              }
            }else if(etapecourante == 1){
              if(nombread<=0){
                FlashToast.showFlashToast(context: context, title: "Erreur", message: "Veillez indiquer votre nombre ", flashType: FlashType.warning,flashPosition: FlashPosition.top);
              }else{
                if (etapecourante < 2) {
                  setState(() {
                    objetfinalReservation.nombre_adulte = nombread;
                    objetfinalReservation.nombre_enfant = nombrekid;
                    etapecourante += 1;
                  });
                }
              }
            }else if(etapecourante == 2){
              final String transactionId0 = Random().nextInt(100000000).toString();
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PaiementReservationv(objet: objetfinalReservation,montant: '200',)));


            }
          },
          onStepCancel: (){
            if(etapecourante >0){
              setState(() {
                etapecourante-=1;
              });
            }
          },
        ),
      )
      /*Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextButton(onPressed: ()async{
                final DateTimeRange? datetimarange = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
                if(datetimarange!= null){
                  setState(() {
                    selectedDate = datetimarange;
                  });
                }
              }, child: Text("Choisir une date")),

              Text("${selectedDate.end}"),

              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: "Quel jour comptez vous venir ?"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Veillez entrer une date d'arrivée";
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(3000),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateArrivee = selectedDate;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                    text: _dateArrivee.toString().split(' ')[0]),
              ),
              SizedBox(height: 16.0),

              TextFormField(
                decoration: InputDecoration(labelText: "Quel jour comptez vous partir : ?"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Veuillez entrer une date de départ";
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(3000),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateDepart = selectedDate;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                    text: _dateDepart.toString().split(' ')[0]),
              ),
              SizedBox(height: 16.0),
              Text("Combien êtes vous?"),
              SizedBox(height: 16.0),
              Text("Adultes : "),
              Row(
                children: [
                  Icon(Icons.man,size: 70,),
                  InkWell(
                    onTap: (){
                      if(nombread > 0 ){
                        setState(() {
                          nombread--;
                        });
                      }
                    },
                      child: Icon(Icons.add_box_rounded,size: 40,)),
                  Text("${nombread}",style: TextStyle(fontSize: 20)),
                  InkWell(
                    onTap: (){
                      setState(() {
                        nombread++;
                      });
                    },
                      child: Icon(Icons.add_box_rounded,size: 40,))
                ],
              ),
              Text("Enfants"),
              Row(
                children: [
                  Icon(Icons.boy,size: 60,),
                  InkWell(
                      onTap: (){
                        if(nombrekid > 0 ){
                          setState(() {
                            nombrekid--;
                          });
                        }
                      },
                      child: Icon(Icons.add_box_rounded,size: 40,)),
                  Text("${nombrekid}",style: TextStyle(fontSize: 20),),
                  InkWell(
                      onTap: (){
                        setState(() {
                          nombrekid++;
                        });
                      },
                      child: Icon(Icons.add_box_rounded,size: 40,))
                ],
              ),
              SizedBox(height: 16.0),
              TextButton(
                child: Text('Valider'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Vous pouvez maintenant utiliser les valeurs de la réservation
                    // en utilisant l'objet _reservation.
                    // Par exemple, vous pouvez les envoyer à un service ou les afficher dans une autre partie de l'application.
                    // Pour cet exemple, nous affichons simplement les valeurs dans la console.
                    print('ID du logement: ${_reservation.id_logement}');
                    print('Date d\'arrivée: ${_dateArrivee}');
                    print('Date de départ: ${_dateDepart}');
                    print('Nombre d\'adultes: ${_reservation.nombre_adulte}');
                    print('Nombre d\'enfants: ${_reservation.nombre_enfant}');
                    print('User id : ${_auth.currentUser!.uid}');
                    Reservation reservation = new Reservation(id_client: _auth.currentUser!.uid, uid: "", id_logement: this.widget.log.uid, date_arrivee: _dateArrivee, date_depart: _dateDepart, nombre_adulte: nombread , nombre_enfant: nombrekid);
                    ReservationRepository rr = new ReservationRepository();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyApp(reservation: reservation,)));
                    _formKey.currentState!.reset();


                  }
                },
              ),
            ],
          ),
        ),
      )*/,
    );
  }
}
