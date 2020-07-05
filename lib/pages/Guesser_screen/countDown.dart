import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GuesserCountDown extends ChangeNotifier {
  int current;
  int initialValue = 82;
  GuesserCountDown() {
    current = initialValue;
  }

  set setCurrent(int a) {
    current = a;
    notifyListeners();
  }
}
