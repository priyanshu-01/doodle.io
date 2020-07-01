import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scribbl/pages/enterName.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authService.dart';
import '../pages/selectRoom.dart';
import '../pages/signIn.dart';
import '../pages/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../virtualCurrency/data.dart';

Currency currency;
String name = '  ', email = '  ', imageUrl = '  ', uid = '  ';
int coins;
String dataDocId = '  ';

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
            return SignIn(); //loading page
          else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.isAnonymous) {
              check = signInMethod.anonymous;
              uid = snapshot.data.uid;
              return fetchFutureAnonymous();
            } else {
              check = signInMethod.google;
              name = snapshot.data.displayName;
              email = snapshot.data.email;
              imageUrl = snapshot.data.photoUrl;
              uid = snapshot.data.uid;
              return fetchFutureGoogle();
            }
          } else
            return LoginPage();
        });
  }
}

Widget fetchFutureAnonymous() {
  return FutureBuilder<QuerySnapshot>(
    future: Firestore.instance
        .collection('users anonymous')
        .where('uid', isEqualTo: uid)
        .getDocuments(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return SignIn();
      else {
        if (snapshot.data.documents.length == 0) {
          name = enteredName;
          coins = 1000;
          AuthSignIn().createAnonymousUser();
        } else {
          DocumentSnapshot a = snapshot.data.documents[0];
          dataDocId = a.documentID;
          coins = a['coins'];
          name = a['name'];
          imageUrl = a['imageUrl'];
          AuthSignIn().activate();
        }
        currency = Currency(coins: coins);
        return SelectRoom(
          currency: currency,
          email: email,
          imageUrl: imageUrl,
          userName: name,
          name: name,
          uid: uid,
        );
      }
    },
  );
}

Widget fetchFutureGoogle() {
  return FutureBuilder<QuerySnapshot>(
    future: Firestore.instance
        .collection('users google')
        .where('uid', isEqualTo: uid)
        .getDocuments(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return SignIn();
      else {
        if (snapshot.data.documents.length == 0) {
          coins = 1000;
          AuthProvider().createGoogleUser();
        } else {
          DocumentSnapshot a = snapshot.data.documents[0];
          dataDocId = a.documentID;
          coins = a['coins'];
          AuthProvider().activate();
        }
        currency = Currency(coins: coins);
        return SelectRoom(
          currency: currency,
          email: email,
          imageUrl: imageUrl,
          userName: name,
          name: name,
          uid: uid,
        );
      }
    },
  );
}
