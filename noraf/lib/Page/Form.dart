import 'package:derniernoraf/Page/utils/CustumText.dart';
import 'package:flutter/material.dart';

import '../Model/Personne.dart';
import '../Repository/AuthentificationService.dart';
import '../Repository/PersonneRepository.dart';
import 'Splashscreen.dart';


class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nom_prenom_mail = GlobalKey<FormState>();
  final _mail_password = GlobalKey<FormState>();
  final _sex_address_telephone_naissance = GlobalKey<FormState>();
  String? selectedGender = "";

  String dropdownValue = "Homme";
  List<String> items = [
    'Homme',
    'Femme'
  ];


  // Variables pour stocker les valeurs du formulaire
  String _nom = '';
  String _prenom = '';
  String _email = '';
  String _motDePasse = '';
  String _sexe = '';
  String _adresse = '';
  String _numeroTelephone = '';
  DateTime _dateNaissance = DateTime.now();
  int etapecourante = 0;

  bool fin = false;

  void pagesuivante(){
    if(etapecourante < 2){
      setState(() {
        etapecourante++;
      });
    }else{
      fin = true;
    }
  }

  void pageprecedannte(){
    if(etapecourante > 0){
      setState(() {
        etapecourante--;
      });
    }
  }


  List<Step> getSteps() =>[
    Step(state: etapecourante >0 ? StepState.complete : StepState.indexed,title: Text("Nom et Prenom"), content: Container(
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

                CustumText("Completez vos informations", Colors.black, "", 18),
                Form(
                  key: _nom_prenom_mail,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Nom'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nom = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Prénom'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un prénom';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _prenom = value!;
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],

            ),
          ),
          ),
        )
    ),isActive: etapecourante >= 0),
    Step(state: etapecourante >1 ? StepState.complete : StepState.indexed,title: Text("Email et Mot de passe"), content: Container(
      child: Form(
        key: _mail_password,
        child: Column(
          children: [
            Wrap(
              children: [
                Text("Entrez votre mail et un Mot de passe",style: TextStyle(fontSize: 20),),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _motDePasse = value!;
                },
                obscureText: true,
              ),
            ),
            SizedBox(height: 16.0),



          ],
        ),
      ),
    ),isActive: etapecourante >= 1),
    Step(state: etapecourante >2 ? StepState.complete : StepState.indexed,title: Text("Complétez vos informations"), content: Container(
        child: Column(
          children: [
            SafeArea(
                child: Center(
                  child: Form(
                    key: _sex_address_telephone_naissance,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: DropdownButton<String>(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
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
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        )

    ),isActive: etapecourante >= 2),
  ];

  @override
  Widget build(BuildContext context) {
    final page = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("I N S C R I P T I O N",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:SafeArea(
        child: Stepper(
          steps: getSteps(),
          onStepContinue: (){
            if(etapecourante == 0) {
              if (_nom_prenom_mail.currentState!.validate()) {
                _nom_prenom_mail.currentState?.save();
                pagesuivante();
              }
            }

            else if(etapecourante == 1) {
              if (_mail_password.currentState!.validate()) {
                _mail_password.currentState?.save();
                pagesuivante();
              }
            }

            else if(etapecourante == 2) {
              if (_sex_address_telephone_naissance.currentState!.validate()) {
                _sex_address_telephone_naissance.currentState?.save();
                pagesuivante();
              }
            }

            if(fin == true){

                print('Nom: $_nom');
                print('Prénom: $_prenom');
                print('Email: $_email');
                print('Mot de passe: $_motDePasse');
                print('Sexe: $dropdownValue');
                print('Adresse: $_adresse');
                print('Numéro de téléphone: $_numeroTelephone');
                print('Date de naissance: $_dateNaissance');
                Personne p = new Personne(role: "user", uid: "uid", id_user: "id_user", nom: "$_nom", prenom: "$_prenom", address: "$_adresse", numero_telephone: "$_numeroTelephone", email: "$_email", motdepass: "$_motDePasse", sexe: "$dropdownValue", date_naissance: "$_dateNaissance", statutpaiement: false, fin_abonnement: DateTime.now());
                AuthentificationService _auth = new AuthentificationService();
                _auth.registerInWithEmailAndPassword(p.email, p.motdepass,p);
                PersonneRepository _perseonnerep = new PersonneRepository();

                Navigator.push(context, MaterialPageRoute(builder: (context)=> Splashscreen()));

            }



          },
          onStepCancel: pageprecedannte,
          currentStep: etapecourante,
        )

        /*SingleChildScrollView(
          child: Center(
            child: Column(

              children: [

                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      decoration: BoxDecoration(

                          color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0))
                      ),

                      width: page.width,
                      height: page.height,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            //Logo de l'application

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("lib/assets/google2.png",scale: 2,),
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            //Un message

                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("Rejoignez nous",style: TextStyle(fontSize: 30,fontFamily: "Acme"),),
                            ),

                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: 'Nom'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un nom';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _nom = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: 'Prénom'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un prénom';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _prenom = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: 'Email'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer une adresse email';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _email = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: 'Mot de passe'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un mot de passe';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _motDePasse = value!;
                                      },
                                      obscureText: true,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: DropdownButton<String>(
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
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
                                  ),


                                  SizedBox(height: 10.0),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState?.save();
                                          // Faire quelque chose avec les valeurs du formulaire
                                          // Par exemple, envoyer une requête HTTP pour enregistrer les données
                                          print('Nom: $_nom');
                                          print('Prénom: $_prenom');
                                          print('Email: $_email');
                                          print('Mot de passe: $_motDePasse');
                                          print('Sexe: $dropdownValue');
                                          print('Adresse: $_adresse');
                                          print('Numéro de téléphone: $_numeroTelephone');
                                          print('Date de naissance: $_dateNaissance');
                                          Personne p = new Personne(role: "user", uid: "uid", id_user: "id_user", nom: "$_nom", prenom: "$_prenom", address: "$_adresse", numero_telephone: "$_numeroTelephone", email: "$_email", motdepass: "$_motDePasse", sexe: "$dropdownValue", date_naissance: "$_dateNaissance", statutpaiement: false, fin_abonnement: DateTime.now());
                                          AuthentificationService _auth = new AuthentificationService();
                                          _auth.registerInWithEmailAndPassword(p.email, p.motdepass,p);
                                          PersonneRepository _perseonnerep = new PersonneRepository();

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Splashscreen()));
                                        }
                                      },
                                      child: Text('Valider',style: TextStyle(color: Colors.black),),
                                    ),
                                  ),
                                  //ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginForm()));}, child: Text("Connexion"))
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                ),





                //Boutton s'inscrire
              ],
            ),
          ),
        )*/,
      )








































      /*Padding(
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
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nom = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prenom = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  _motDePasse = value!;
                },
                obscureText: true,
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
                    print('Nom: $_nom');
                    print('Prénom: $_prenom');
                    print('Email: $_email');
                    print('Mot de passe: $_motDePasse');
                    print('Sexe: $dropdownValue');
                    print('Adresse: $_adresse');
                    print('Numéro de téléphone: $_numeroTelephone');
                    print('Date de naissance: $_dateNaissance');
                    Personne p = new Personne(role: "user", uid: "uid", id_user: "id_user", nom: "$_nom", prenom: "$_prenom", address: "$_adresse", numero_telephone: "$_numeroTelephone", email: "$_email", motdepass: "$_motDePasse", sexe: "$dropdownValue", date_naissance: "$_dateNaissance");
                    AuthentificationService _auth = new AuthentificationService();
                    _auth.registerInWithEmailAndPassword(p.email, p.motdepass,p);
                    PersonneRepository _perseonnerep = new PersonneRepository();

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Splashscreen()));
                  }
                },
                child: Text('Valider'),
              ),
              ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginForm()));}, child: Text("Connexion"))
            ],
          ),
        ),
      )*/,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserForm(),
  ));
}
