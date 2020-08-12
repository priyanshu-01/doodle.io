import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scribbl/OverlayManager/overlayBuilder.dart';
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
String name = '  ', email = '  ', imageUrl = '  ', uid = '  ';
int coins;
String dataDocId = '  ';
DocumentSnapshot userFirebaseDocument;
int gamesPlayed;
DocumentSnapshot avatarDocument;
OverlayBuilder overlayBuilder;
enum signInMethod { google, anonymous }
var check = signInMethod.anonymous;
AsyncSnapshot userAuthenticationSnapshot;

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    overlayBuilder = OverlayBuilder();

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
          //   name: name,
          //   uid: uid,
          //   userName: userNam,
          // );
          userAuthenticationSnapshot = snapshot;
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading(); //loading page
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
          // LoginPage
          {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              overlayBuilder.show(context, LoginOptions(), doNotDismiss: true);
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
          // name = enteredName;
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
  bool dataInitialised = false;
  @override
  void initState() {
    initialiseWorkingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (
        // !soundsLoaded || avatarDocument == null
        !dataInitialised) {
      print('loading...');
      return Loading();
    } else
      return SelectRoom(
          userName: name,
          currency: currency,
          uid: uid,
          imageUrl: imageUrl,
          name: name,
          email: email);
  }

  initialiseWorkingData() {
    currency = Currency(coins: coins);
    audioPlayer = AudioPlayer();
    audioPlayer.initialiseSounds().whenComplete(() => getAvatars()
        // setState(() {
        //       print('sound Loaded');
        //       soundsLoaded = true;
        //     })

        );
  }

  Future<void> getAvatars() async {
    await Firestore.instance
        .collection('avatars')
        .document('images')
        .get()
        .then((value) {
      setState(() {
        avatarDocument = value;
        dataInitialised = true;
        //  imageUrl= av.data['images'][0];
      });
    });
  }
}
