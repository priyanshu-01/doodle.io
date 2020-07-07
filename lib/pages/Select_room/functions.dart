import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:connectivity/connectivity.dart';
import 'package:scribbl/services/authHandler.dart';

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });

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

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
