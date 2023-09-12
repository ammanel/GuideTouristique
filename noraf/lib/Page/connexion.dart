import 'dart:async';

import 'package:derniernoraf/Page/utils/CustumText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



import '../Repository/AuthentificationService.dart';
import 'Acceuil.dart';
import 'ForgotPassword/forgotpassword.dart';
import 'Form.dart';
import 'Splashscreen.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  AuthentificationService _authentificationService = new AuthentificationService();
  bool loading = true;
  String error = "";

  // Variables pour stocker les valeurs du formulaire
  String _email = '';
  String _motDePasse = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final page = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff1195d5),
      body: SingleChildScrollView(
        child: Column(

          children: [

            Container(
                height: page.height,

                decoration: BoxDecoration(
                    color: Colors.grey[100],
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
                  /*image: DecorationImage(
                    opacity: 50,
                    image: NetworkImage("https://www.republicoftogo.com/var/site/storage/images/toutes-les-rubriques/tourisme/cascade-de-bonnes-nouvelles2/2741318-1-fre-FR/cascade-de-bonnes-nouvelles_i1920.jpg"),
                    fit: BoxFit.cover,
                  )*/
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                     children: [
                       //Logo
                        SizedBox(
                          height: page.height/10,
                        ),
                       SizedBox(
                         width: 200,
                         height: 200,
                         child: CupertinoContextMenu(
                           child: Image.asset("lib/assets/Fichier 3.png",),
                             actions: [
                               CupertinoContextMenuAction(child: Text("Retour"),onPressed: (){Navigator.pop(context);},)
                             ],
                         ),
                       ),

                       //Text
                       SizedBox(
                         height: page.height/20,
                       ),
                       Text("Vous nous avez manqué..!",style: TextStyle(fontSize: 26,color: Colors.black,fontFamily: "Acme"),),
                       SizedBox(
                         height: page.height/30,
                       ),

                       Text("$error",style: TextStyle(color: Colors.red),),
                       //Username

                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
                         child: TextFormField(
                           decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.black)),
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
                       SizedBox(
                         height: page.height/100,
                       ),

                       //Password

                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
                         child: TextFormField(
                           decoration: InputDecoration(labelText: 'Mot de passe',labelStyle: TextStyle(color: Colors.black)),
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



                       //Forgot Password

                       Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           TextButton(onPressed: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=> forgotpassword()));
                           }, child: Text("Mot de passe oublié?",style: TextStyle(color: Colors.black),)),
                         ],
                       ),



                       //Login with google button

                       Row(

                         children: [
                           SizedBox(width: MediaQuery.of(context).size.width/16,),
                           TextButton(onPressed: () async{

                             print("Se connecter");
                             if (_formKey.currentState!.validate()) {
                               _formKey.currentState?.save();

                               // Faire quelque chose avec les valeurs du formulaire
                               // Par exemple, envoyer une requête HTTP pour vérifier les informations de connexion
                               print('Email: $_email');
                               print('Mot de passe: $_motDePasse');
                               AuthentificationService _authService = new AuthentificationService();
                               final request = await _authService.signInWithEmailAndPassword("$_email", "$_motDePasse");





                               if(request == null){
                                 print("Erreur lors de la connexion");
                                 setState(() {
                                   loading = true;
                                   error = "Address ou mot de passe incorrect";
                                 });





                               }else{
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
                               }
                             }
                           },
                             child: Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.black,
                               ),
                               width: MediaQuery.of(context).size.width/1.2,
                               height: 50,

                               child: Center(child: Text("Se connecter",style: TextStyle(color: Colors.white),)),
                             ),),
                           Icon(Icons.navigate_next_outlined,color: Colors.white,)
                         ],
                       ),
                       TextButton(onPressed: () async{
                         try{
                           print("Execution de la methode");

                           final user =  _authentificationService.SignInWithGoogle(context);
                         }catch(e)
                         {
                           print("Erreur est la suivante : "+e.toString());
                         }

                       }, child: Container(
                         height: 50,
                         width: MediaQuery.of(context).size.width/1.2,
                         decoration: BoxDecoration(
                             color: Colors.grey[300],
                             borderRadius: BorderRadius.all(Radius.circular(10))
                         ),

                         child: Container(

                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   Image.asset("lib/assets/google.png",width: 29),
                                   CustumText("Se connecter avec google", Colors.black, "Acme", 18),
                                   SizedBox()
                                 ],
                               )),

                       )),

                       TextButton(onPressed: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> UserForm()));
                       }, child: Text("Pas encore membre...?Inscrivez-vous",style: TextStyle(color: Colors.blue),)),


                       //Sign in Button


                     ],
                    ),
                  ),
                ),
              ),




          ],
        ),
      )



      /*loading ? Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ElevatedButton(onPressed: () async{
                try{
                  print("Execution de la methode");
                  final user =  _authentificationService.SignInWithGoogle(context);
                }catch(e)
                {
                  print("Erreur est la suivante : "+e.toString());
                }

              }, child: Text("Continuer avec google")),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> forgotpassword()));
              }, child: Text("Mot de passe oublié")),
              SizedBox(height: 16.0),
              Text("$error",style: TextStyle(color: Colors.red),),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    // Faire quelque chose avec les valeurs du formulaire
                    // Par exemple, envoyer une requête HTTP pour vérifier les informations de connexion
                    print('Email: $_email');
                    print('Mot de passe: $_motDePasse');
                    AuthentificationService _authService = new AuthentificationService();
                    final request = await _authService.signInWithEmailAndPassword("$_email", "$_motDePasse");
                    setState(() {
                      loading = false;
                    });

                    startTimer(_auth, context);


                    if(request == null){
                      print("Erreur lors de la connexion");
                      setState(() {
                        loading = true;
                        error = "Erreur lors de la connexion";
                      });


                    }
                    }
                },

                child: Text('Se connecter'),
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UserForm()));
              }, child: Text("Inscription"))
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),*/
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginForm(),
  ));
}


void startTimer(_auth,context) {
  const duration = Duration(seconds: 5);

  Timer(duration, () {
    // Code à exécuter après la durée spécifiée (5 secondes)
    if(_auth.currentUser?.uid != null)
    {


      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
    }
  });
}