import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scribbl/OverlayManager/informationOverlayBuilder.dart';
import 'package:scribbl/OverlayManager/necessaryOverlayBuilder.dart';
import 'package:scribbl/audioPlayer/audioPlayer.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/loginOptions.dart';
import 'package:scribbl/pages/enterName.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authService.dart';
import '../pages/Select_room/selectRoom.dart';
import '../pages/signIn.dart';
import '../pages/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../virtualCurrency/data.dart';
import '../pages/Painter_screen/wordCheck/wordCheck.dart';

WordCheck wordCheck;
Currency currency;
String name, email, imageUrl, uid;
int coins;
String dataDocId;
DocumentSnapshot userFirebaseDocument;
int gamesPlayed;
DocumentSnapshot avatarDocument;
InformationOverlayBuilder informationOverlayBuilder;
NecessaryOverlayBuilder necessaryOverlayBuilder;
enum signInMethod { google, anonymous }
var checkSignInMethod = signInMethod.anonymous;
enum status { signedIn, notSignedIn }
var signInStatus = status.notSignedIn;
AsyncSnapshot userAuthenticationSnapshot;

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          // return SelectRoom(
          //   currency: currency,
          //   email: email,
          //   imageUrl: imageUrl,
          //   uid: uid,
          //   userName: userNam,
          // );
          userAuthenticationSnapshot = snapshot;
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading(); //loading page
          else if (snapshot.hasData && snapshot.data != null) {
            signInStatus = status.signedIn;

            if (necessaryOverlayBuilder.overlayEntry != null) {
              necessaryOverlayBuilder.hide();
              necessaryOverlayBuilder.overlayEntry = null;
            }

            if (snapshot.data.isAnonymous) {
              checkSignInMethod = signInMethod.anonymous;
              uid = snapshot.data.uid;
              return fetchFutureAnonymous();
            } else {
              checkSignInMethod = signInMethod.google;
              name = snapshot.data.displayName;
              email = snapshot.data.email;
              imageUrl = snapshot.data.photoUrl;
              uid = snapshot.data.uid;
              return fetchFutureGoogle();
            }
          } else
          // LoginPage
          {
            signInStatus = status.notSignedIn;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              necessaryOverlayBuilder.show(context);
            });
            return Loading();
          }
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
        return Loading();
      else {
        if (snapshot.data.documents.length == 0) {
          coins = 200;
          wordCheck = WordCheck();
          AnonymousAuthentication().createAnonymousUser();
        } else {
          userFirebaseDocument = snapshot.data.documents[0];
          dataDocId = userFirebaseDocument.documentID;
          coins = userFirebaseDocument['coins'];
          name = userFirebaseDocument['name'];
          imageUrl = userFirebaseDocument['imageUrl'];
          wordCheck = WordCheck(userFirebaseDocument: userFirebaseDocument);
          gamesPlayed = userFirebaseDocument['gamesPlayed'];
          (gamesPlayed == null) ? gamesPlayed = 0 : null;
          AnonymousAuthentication().activate();
        }
        return LoadingCompleted();
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
        return Loading();
      else {
        if (snapshot.data.documents.length == 0) {
          coins = 200;
          wordCheck = WordCheck();
          GoogleAuthentication().createGoogleUser();
        } else {
          userFirebaseDocument = snapshot.data.documents[0];
          dataDocId = userFirebaseDocument.documentID;
          coins = userFirebaseDocument['coins'];
          name = userFirebaseDocument['name'];
          imageUrl = userFirebaseDocument['imageUrl'];
          wordCheck = WordCheck(userFirebaseDocument: userFirebaseDocument);
          gamesPlayed = userFirebaseDocument['gamesPlayed'];
          (gamesPlayed == null) ? gamesPlayed = 0 : null;
          GoogleAuthentication().activate();
        }
        return LoadingCompleted();
      }
    },
  );
}

class LoadingCompleted extends StatefulWidget {
  @override
  _LoadingCompletedState createState() => _LoadingCompletedState();
}

class _LoadingCompletedState extends State<LoadingCompleted> {
  // bool soundsLoaded = false;
  @override
  void initState() {
    currency = Currency(coins: coins);
    repeatedWords();
    super.initState();
  }

  Future<void> repeatedWords() async {
    await Firestore.instance
        .collection('words')
        .document('word list')
        .get()
        .then((value) {
      wordList = removeRepeatedWords(value);
    });
  }

  List removeRepeatedWords(DocumentSnapshot documentSnapshot) {
    List allWords = documentSnapshot['list'];
    List freshWords = [];
    for (String i in allWords) {
      if (wordCheck.myAttemptedWords.indexOf(i) == -1) {
        freshWords.add(i);
      }
    }
    return freshWords;
  }

  @override
  Widget build(BuildContext context) {
    myUserName = name;
    myUserName.trim();
    myUserName = firstName(myUserName);

    return SelectRoom(
        currency: currency,
        uid: uid,
        imageUrl: imageUrl,
        name: name,
        email: email);
  }
}
