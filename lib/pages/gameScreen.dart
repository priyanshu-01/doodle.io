import 'package:flutter/material.dart';
import 'Painter_screen/painterScreen.dart';
import 'Guesser_screen/guesserScreen.dart';
import 'room/room.dart';
import 'selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result.dart';

List displayNames;
List displayScores;
String docId;

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return GuesserScreen();
    if (round <= numberOfRounds) {
      if (denId == identity) {
        //  denCanvasLength = totalLength*(7/12);
        denCanvasLength = (totalLength - 20) * (2 / 3) * (9 / 11);
        updateDimension();
        return PainterScreen();
      } else
        return GuesserScreen();
    } else {
      docId = documentid;
      displayNames = players;
      displayScores = finalScore;
      // Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Result()) );
      // if(identity==hostId)
      // delDoc();
      // flag=0;
      // setState(() {
      // });
      print('still in gameScreen');
      return Result();
    }
  }
}

Future<void> delDoc() async {
  await Firestore.instance
      .collection('rooms')
      .document(docId)
      .delete()
      .catchError((e) {
    print(e);
    print('its an error');
  });
}

Future<void> updateDimension() async {
  if (roomData['denCanvasLength'] != denCanvasLength)
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'denCanvasLength': denCanvasLength});
}
