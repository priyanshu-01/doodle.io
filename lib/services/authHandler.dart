import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scribbl/OverlayManager/informationOverlayBuilder.dart';
import 'package:scribbl/OverlayManager/necessaryOverlayBuilder.dart';
import 'package:scribbl/main.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authService.dart';
import '../pages/Select_room/selectRoom.dart';
import '../pages/signIn.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../virtualCurrency/data.dart';
import '../pages/Painter_screen/wordCheck/wordCheck.dart';

WordCheck wordCheck;
Currency currency;
String name, email, imageUrl, uid;
int coins;
String userFirebaseDocumentId;
Map userFirebaseDocumentMap;
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
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('stream triggered');
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
            print('user signed in');
            signInStatus = status.signedIn;

            if (necessaryOverlayBuilder.overlayEntry != null) {
              print('necessary overlay hidden');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print('yes!!hidden');
                necessaryOverlayBuilder.hide();
              });

              // necessaryOverlayBuilder.overlayEntry = null;
            }

            if (snapshot.data.isAnonymous) {
              checkSignInMethod = signInMethod.anonymous;
              uid = snapshot.data.uid;
              // analytics.setUserId(uid);
              setUserId();
              return fetchFutureAnonymous();
            } else {
              checkSignInMethod = signInMethod.google;
              name = snapshot.data.displayName;
              email = snapshot.data.email;
              imageUrl = snapshot.data.photoURL;
              uid = snapshot.data.uid;
              // analytics.setUserId(uid);
              setUserId();
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

Future<void> setUserId() async {
  await analytics.setUserId(uid);
}

Widget fetchFutureAnonymous() {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('users anonymous')
        .where('uid', isEqualTo: uid)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Loading();
      else {
        if (snapshot.data.docs.length == 0) {
          coins = 200;
          wordCheck = WordCheck();
          AnonymousAuthentication().createAnonymousUser();
        } else {
          userFirebaseDocumentMap = snapshot.data.docs[0].data();
          userFirebaseDocumentId = snapshot.data.docs[0].id;
          coins = userFirebaseDocumentMap['coins'];
          name = userFirebaseDocumentMap['name'];
          imageUrl = userFirebaseDocumentMap['imageUrl'];
          wordCheck = WordCheck(userFirebaseDocument: userFirebaseDocumentMap);
          gamesPlayed = userFirebaseDocumentMap['gamesPlayed'];
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
    future: FirebaseFirestore.instance
        .collection('users google')
        .where('uid', isEqualTo: uid)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting)
        return Loading();
      else {
        if (snapshot.data.docs.length == 0) {
          coins = 200;
          wordCheck = WordCheck();
          GoogleAuthentication().createGoogleUser();
        } else {
          userFirebaseDocumentMap = snapshot.data.docs[0].data();
          userFirebaseDocumentId = snapshot.data.docs[0].id;
          coins = userFirebaseDocumentMap['coins'];
          name = userFirebaseDocumentMap['name'];
          imageUrl = userFirebaseDocumentMap['imageUrl'];
          wordCheck = WordCheck(userFirebaseDocument: userFirebaseDocumentMap);
          gamesPlayed = userFirebaseDocumentMap['gamesPlayed'];
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
    await FirebaseFirestore.instance
        .collection('words')
        .doc('word list')
        .get()
        .then((value) {
      wordList = removeRepeatedWords(value);
    });
  }

  List removeRepeatedWords(DocumentSnapshot documentSnapshot) {
    List allWords = documentSnapshot.data()['list'];
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
