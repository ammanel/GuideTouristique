import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'Page/Chargement/chargement.dart';
import 'Page/Splashscreen.dart';
import 'Repository/AuthentificationService.dart';

import 'Model/user.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(name: 'norafbg',options: FirebaseOptions(apiKey: 'AIzaSyDLyf1xHNCuztsOs6qKICDKbPKW_Ih7sP0', appId: '1:794671351080:android:9ce56c8e1889938bac7c1d', messagingSenderId: '794671351080', projectId: 'noraf-f086a'),);
  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthentificationService().user,
      initialData: null,
      child: MaterialApp(
        home: chargementpage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData
          (
          primarySwatch: Colors.blue,

        ),
      ),
    );
  }
}
