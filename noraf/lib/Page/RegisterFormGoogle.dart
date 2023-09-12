import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/Personne.dart';
import '../Repository/AuthentificationService.dart';
import '../Repository/PersonneRepository.dart';
import 'Acceuil.dart';


class RegisterFormGoogle extends StatefulWidget {

  final UserCredential user;
  RegisterFormGoogle({required this.user});

  @override
  _RegisterFormGoogle createState() => _RegisterFormGoogle();
}

class _RegisterFormGoogle extends State<RegisterFormGoogle> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _nom = '';
  String _sexe = '';
  String _adresse = '';
  String _numeroTelephone = '';
  DateTime _dateNaissance = DateTime.now();
  String dropdownValue = "Homme";
  List<String> items = [
    'Homme',
    'Femme'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
    appBar: AppBar(
        title: Text('Formulaire Utilisateur'),
        backgroundColor: Colors.white,
        elevation:0 ,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un pseudo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nom = value!;
                },
              ),



              DropdownButton<String>(
                value: dropdownValue,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue ?? 'Homme';
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
                onSaved: (value) {
                  _adresse = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numeroTelephone = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date de naissance'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une date de naissance';
                  }
                  return null;
                },
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dateNaissance = selectedDate;
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(
                    text: _dateNaissance.toString().split(' ')[0]),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Faire quelque chose avec les valeurs du formulaire
                    // Par exemple, envoyer une requête HTTP pour enregistrer les données

                    Personne p = new Personne(role: "user", uid: "${this.widget.user.user?.uid}", id_user: "id_user", nom: "${this.widget.user.user?.displayName}", prenom: "$_nom", address: "$_adresse", numero_telephone: "$_numeroTelephone", email: "${this.widget.user.user?.email}", motdepass: "", sexe: "$dropdownValue", date_naissance: "$_dateNaissance", statutpaiement: false, fin_abonnement: DateTime.now());
                    AuthentificationService _auth = new AuthentificationService();

                    PersonneRepository _perseonnerep = new PersonneRepository();
                    _perseonnerep.AjoutPersonne(p);

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Acceuil()));
                  }
                },
                child: Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

