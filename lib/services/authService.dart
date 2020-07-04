import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<bool> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return false;

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    AuthResult authResult = await _auth.signInWithCredential(credential);

    if (authResult.user == null) return false;

    print("signInWithGoogle succeeded");

    return true;
  }

  Future<void> signOutGoogle() async {
    name = '  ';
    imageUrl = '  ';
    email = '  ';
    uid = '  ';
    coins = 0;
    AuthProvider().deactivate();
    print("signOutWithGoogle succeeded");
    await _auth.signOut();
  }

  Future<void> createGoogleUser() async {
    await Firestore.instance.collection('users google').add({
      'uid': uid,
      'coins': coins,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'active': true,
      'attemptedWords': [],
    }).then((value) {
      dataDocId = value.documentID;
    });
  }

  Future<void> activate() async {
    await Firestore.instance
        .collection('users google')
        .document(dataDocId)
        .updateData({'active': true});
  }

  Future<void> deactivate() async {
    await Firestore.instance
        .collection('users google')
        .document(dataDocId)
        .updateData({'active': false});
  }
}
