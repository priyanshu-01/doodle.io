import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'room.dart';
import 'painterScreen.dart';
import 'guesserScreen.dart';
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      if(denId==identity)
              return PainterScreen();
      else
        return GuesserScreen();
  }
}


