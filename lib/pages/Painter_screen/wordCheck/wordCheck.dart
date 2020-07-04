import 'package:cloud_firestore/cloud_firestore.dart';

class WordCheck {
  List myAttemptedWords;
  WordCheck(DocumentSnapshot userFirebaseDocument) {
    myAttemptedWords = userFirebaseDocument['attemptedWords'];
  }

  void addWord(String newWord) {
    myAttemptedWords = myAttemptedWords + [newWord];
  }
}
