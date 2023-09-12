import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashtoast/flash_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../Model/Personne.dart';
import '../../Repository/PersonneRepository.dart';
import '../utils/CustumText.dart';

class PersonneForm extends StatefulWidget {
  final Personne personne;

  PersonneForm({required this.personne});

  @override
  _PersonneFormState createState() => _PersonneFormState();
}

class _PersonneFormState extends State<PersonneForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _addressController;
  late TextEditingController _numeroTelephoneController;
  late TextEditingController _emailController;
  late TextEditingController _motDePasseController;
  late TextEditingController _sexeController;
  late TextEditingController _naissanceController;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _naissanceController = TextEditingController(text: widget.personne.date_naissance);
    _nomController = TextEditingController(text: widget.personne.nom);
    _prenomController = TextEditingController(text: widget.personne.prenom);
    _addressController = TextEditingController(text: widget.personne.address);
    _numeroTelephoneController = TextEditingController(text: widget.personne.numero_telephone);
    _motDePasseController = TextEditingController(text: widget.personne.motdepass);
    _sexeController = TextEditingController(text: widget.personne.sexe);
    _emailController=TextEditingController(text: widget.personne.email);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _addressController.dispose();
    _numeroTelephoneController.dispose();
    _motDePasseController.dispose();
    _sexeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.back,color: Colors.black,)),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
                Personne pr = new Personne(role: "role", uid: _auth.currentUser!.uid, id_user: "id_user", nom: _nomController.text, prenom: _prenomController.text, address: _addressController.text, numero_telephone: _numeroTelephoneController.text, email: _emailController.text, motdepass: _motDePasseController.text, sexe: _sexeController.text, date_naissance: _naissanceController.text, statutpaiement: this.widget.personne.statutpaiement, fin_abonnement: this.widget.personne.fin_abonnement);
                PersonneRepository personnrepo = new PersonneRepository();
                personnrepo.UpdatePersonne(pr);
                FlashToast.showFlashToast(context: context, title: "Succes", message: "Vos informations ont bien été mis à jour", flashType: FlashType.success,flashPosition: FlashPosition.top);
              }else{
              print("Erreur ");
            }



              // Afficher un message de réussite
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));

          }, child: Text("Enregister",style: TextStyle(color: Colors.black),))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      child: Wrap(
                        children: [
                          CustumText("Modifier mes informations personnelles", Colors.black, "Acme", 30),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                      hintText: "Nom",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],



                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.5)
                    ),

                      hintText: "Prenom",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],



                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),

                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],



                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _numeroTelephoneController,
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),

                      hintText: "Numero de téléphone",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],
                    enabled: false,



                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),

                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],
                    enabled: false,



                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    // Add email validation logic here if needed
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _motDePasseController,
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),

                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],
                    enabled: false,



                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _sexeController,
                  decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.5)
                      ),

                      hintText: "Sex",
                      hintStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.grey[100],



                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updatePersonne() {
    // Get the form values and update the Personne object
    widget.personne.nom = _nomController.text;
    widget.personne.prenom = _prenomController.text;
    widget.personne.address = _addressController.text;
    widget.personne.numero_telephone = _numeroTelephoneController.text;
    widget.personne.email = _emailController.text;
    widget.personne.motdepass = _motDePasseController.text;
    widget.personne.sexe = _sexeController.text;

    // Do something with the updated personne object, e.g., save it to a database

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
