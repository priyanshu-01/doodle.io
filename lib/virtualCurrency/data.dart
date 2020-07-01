import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Currency extends ChangeNotifier {
  int coins;
  int lastValueCoins;
  Currency({this.coins}) {
    lastValueCoins = coins;
  }

  int get remainingCoins => coins;

  set setCoins(int a) {
    // lastValueCoins = coins;
    coins = a;
    notifyListeners();
  }
}
