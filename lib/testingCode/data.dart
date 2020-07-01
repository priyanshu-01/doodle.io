import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataHolder extends ChangeNotifier {
  Color _color1 = Colors.blue;
  Color _color2 = Colors.red;

  Color get color1 => _color1;

  Color get color2 => _color2;

  set myColor1(Color a) {
    _color1 = a;
    notifyListeners();
  }

  set myColor2(Color b) {
    _color2 = b;
    notifyListeners();
  }
}
