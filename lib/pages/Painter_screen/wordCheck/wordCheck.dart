import 'package:cloud_firestore/cloud_firestore.dart';

class WordCheck {
  List myAttemptedWords;
  DocumentSnapshot userFirebaseDocument;
  WordCheck({this.userFirebaseDocument}) {
    if (userFirebaseDocument != null)
      myAttemptedWords = userFirebaseDocument['attemptedWords'];
    else
      myAttemptedWords = [];
  }

  void addWord(String newWord) {
    myAttemptedWords = myAttemptedWords + [newWord];
  }
}
