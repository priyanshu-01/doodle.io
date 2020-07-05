import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Currency extends ChangeNotifier {
  int coins;
  int lastValueCoins;
  Color coinsAmountColor;
  Currency({this.coins}) {
    lastValueCoins = coins;
    coinsAmountColor = Colors.white;
  }

  set coinsColor(Color a) {
    coinsAmountColor = a;
    notifyListeners();
  }

  int get remainingCoins => coins;

  set setCoins(int a) {
    // lastValueCoins = coins;
    coins = a;
    notifyListeners();
  }
}
