import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RoomData extends ChangeNotifier {
  void rebuildRoom() {
    notifyListeners();
  }
}

class GameScreenData extends ChangeNotifier {
  void rebuildGameScreen() {
    notifyListeners();
  }
}

class ChatData extends ChangeNotifier {
  void rebuildChat() {
    notifyListeners();
  }
}

class GuessersIdData extends ChangeNotifier {
  void rebuildGuessersId() {
    notifyListeners();
  }
}

class CustomPainterData extends ChangeNotifier {
  void rebuildGuesserCustomPainter() {
    notifyListeners();
  }
}
