import 'dart:async';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Repository/AuthentificationService.dart';

class forgotpassword extends StatefulWidget {
  @override
  _forgotpasswordState createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  AuthentificationService _auth = new AuthentificationService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void startTimer(_auth,context) {



  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      const duration = Duration(seconds: 5);
      String email = _emailController.text;
      showDialog(context: context, builder: (context){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Lottie.asset("lib/assets/28823-message-sent.json"),
          ),
        );
      });

      Timer(duration, () {
        // Code à exécuter après la durée spécifiée
        try{
          _auth.sendpasswordrest(email,context);
          ElegantNotification.success(
            title:  Text("Message envoyé"),
            description:  Text("Consultez votre boîte mail"),
            //animationDuration: Duration(milliseconds: 5),
          ).show(context);

        }catch(e)
        {
          Navigator.pop(context);
        }
      });



      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1195d5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(0),topLeft: Radius.circular(0))
                    ),

                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Lottie.asset("lib/assets/75988-forgot-password.json"),
                            SizedBox(
                              height: 80,
                            ),
                            FittedBox(child: Text("Avez vous oublié votre mot de passe?",style: TextStyle(fontFamily: "Acme",fontSize: 25),))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Adresse e-mail de récupération',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Veuillez entrer une adresse e-mail';
                              }
                              if (!value.contains('@')) {
                                return 'Veuillez entrer une adresse e-mail valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: TextButton(
                            onPressed: _submitForm,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 50,

                              child: Center(child: Text("Valider",style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
