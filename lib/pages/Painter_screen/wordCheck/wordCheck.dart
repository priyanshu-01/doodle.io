class WordCheck {
  List myAttemptedWords;
  Map userFirebaseDocument;
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
