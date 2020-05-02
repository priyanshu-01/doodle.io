import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/selectRoom.dart';
import '../pages/signIn.dart';
import '../pages/name2.dart';
import 'package:flutter/services.dart';
String name='  ', email='  ', imageUrl='  ';

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SignIn();//loading page
          else if (snapshot.hasData && snapshot.data != null) {
            name = snapshot.data.displayName;
            email = snapshot.data.email;
            imageUrl = snapshot.data.photoUrl;
            return SelectRoom(userName:name);
          } else
            return NamePage();
        });
  }
}