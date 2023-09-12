import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/Personne.dart';
import '../Model/user.dart';
import '../Page/Acceuil.dart';
import 'PersonneRepository.dart';


class AuthentificationService{
final FirebaseAuth _auth = FirebaseAuth.instance;


AppUser? _userFromFireBaseUser(User? user){
return user != null ? AppUser(uid: user.uid) : null;
}

Stream<AppUser?> get user{

return _auth.authStateChanges().map(_userFromFireBaseUser);

}

Future sendpasswordrest(String email,context) async{
	try{
		_auth.sendPasswordResetEmail(email: email);
		Navigator.pop(context);
		Navigator.pop(context);
	}catch(e)
	{
		print(e);
	}
}

Future signInWithEmailAndPassword(String email,String password) async{
try{
	_auth.authStateChanges().listen((User? user) {
	if (user == null) {
	print('User is currently signed out!');
	}else {
	print('User is signed in!');
}
});



UserCredential result =await _auth.signInWithEmailAndPassword(email: email, password: password);User? user = result.user;
return _userFromFireBaseUser(user);

}catch(exeption){
	print("Lerreur est la suivante : "+exeption.toString());
	return null;
}
}

Future SignInWithGoogle(context) async{

	try {
	  final a = await GoogleSignIn().signIn();
		if(a != null){
			final GoogleSignInAuthentication googleauth = await a.authentication;

			final credential = GoogleAuthProvider.credential(
				accessToken: googleauth.accessToken,
				idToken: googleauth.idToken
			);

			final user = await FirebaseAuth.instance.signInWithCredential(credential);
			Navigator.pop(context);

			PersonneRepository pr = new PersonneRepository();
			print(pr.readPersonneGoogle(Personne(role: "role", uid: "${_auth.currentUser!.uid}", id_user: "id_user", nom: "nom", prenom: "prenom", address: "address", numero_telephone: "numero_telephone", email: "email", motdepass: "motdepass", sexe: "sexe", date_naissance: "date_naissance", statutpaiement: false, fin_abonnement: DateTime.now()),context,user));

			}else{
			print("Lors de la connexion on a eu un null");
		}
	} on Exception catch (e) {

	}
}

Future SignoutWithGoogle() async{

	await GoogleSignIn().signOut();
}

Future registerInWithEmailAndPassword(String email,String password,Personne p) async{
try{
	print('Inscription')
;_auth.authStateChanges().listen((User? user) 
{
if (user == null) {
print('User is currently signed out!');
} else 
{
print('User is signed in!');
}
PersonneRepository pr = new PersonneRepository();
p.uid = user!.uid;
p.id_user = p.uid;
pr.AjoutPersonne(p);
});

UserCredential result =await _auth.createUserWithEmailAndPassword(email: email, password: password);
User? user = result.user;
return _userFromFireBaseUser(user);
}
catch(exeption){
print(exeption.toString());
}

}




Future signOut() async{
try{
	return await _auth.signOut();
}catch(exeption){
print(exeption.toString());
return null;
}
}
}