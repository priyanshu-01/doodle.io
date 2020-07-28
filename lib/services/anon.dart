import 'package:firebase_auth/firebase_auth.dart';
import 'authHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/enterName.dart';

class AuthSignIn {
  Future<void> activate() async {
    await Firestore.instance
        .collection('users anonymous')
        .document(dataDocId)
        .updateData({'active': true});
  }

  Future<void> deactivate() async {
    await Firestore.instance
        .collection('users anonymous')
        .document(dataDocId)
        .updateData({'active': false});
  }

  Future<void> createAnonymousUser() async {
    await Firestore.instance.collection('users anonymous').add({
      'uid': uid,
      'coins': coins,
      'name': enteredName,
      'active': true,
      'imageUrl': imageUrl,
      'attemptedWords': [],
      'gamesPlayed': 0,
    }).then((value) {
      dataDocId = value.documentID;
    });
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }
}

Future<void> signOut() async {
  try {
    await AuthSignIn().deactivate();
    name = '  ';
    uid = '  ';
    dataDocId = '  ';
    enteredName = '';
    coins = 0;
    print('signoutAnonymous success');
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }
}
