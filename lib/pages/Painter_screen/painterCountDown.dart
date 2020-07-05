import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PainterCountDown extends ChangeNotifier {
  int current;
  int initialValue = 80;
  PainterCountDown() {
    current = initialValue;
  }

  set setCurrent(int a) {
    current = a;
    notifyListeners();
  }
}
