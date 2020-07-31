import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
import '../Painter_screen/painterScreen.dart';
import '../Guesser_screen/guesserScreen.dart';
import 'room.dart';
import '../Select_room/selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<GameScreenData>(context);
    // return GuesserScreen();
    if (denId == identity) {
      updateDimension();
      return PainterScreen();
    } else
      return GuesserScreen();
  }
}

Future<void> delDoc() async {
  await Firestore.instance
      .collection('rooms')
      .document(documentid)
      .delete()
      .catchError((e) {
    print(e);
    print('its an error');
  });
}

Future<void> updateDimension() async {
  if (roomData['denCanvasLength'] != myDenCanvasLength)
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'denCanvasLength': myDenCanvasLength});
}
