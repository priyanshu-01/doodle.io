import 'package:firebase_auth/firebase_auth.dart';
import 'authHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnonymousAuthentication {
  Future<void> activate() async {
    await FirebaseFirestore.instance
        .collection('users anonymous')
        .doc(userFirebaseDocumentId)
        .update({'active': true});
  }

  Future<void> deactivate() async {
    await FirebaseFirestore.instance
        .collection('users anonymous')
        .doc(userFirebaseDocumentId)
        .update({'active': false});
  }

  Future<void> createAnonymousUser() async {
    await FirebaseFirestore.instance.collection('users anonymous').add({
      'uid': uid,
      'coins': coins,
      'name': name,
      'active': true,
      'imageUrl': imageUrl,
      'attemptedWords': [],
      'gamesPlayed': 0,
    }).then((value) {
      value.get().then((value) => userFirebaseDocumentMap = value.data());
      userFirebaseDocumentId = value.id;
    });
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOutAnonymous() async {
    try {
      await AnonymousAuthentication().deactivate();
      // name = '  ';
      // uid = '  ';
      // dataDocId = '  ';
      // coins = 0;
      print('signoutAnonymous success');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }
}
