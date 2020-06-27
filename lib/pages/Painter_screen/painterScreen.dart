import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painter/painter.dart';
import '../room/room.dart';
import '../chooseWord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
import '../Guesser_screen/guesserScreen.dart';
import '../Guesser_screen/chat.dart';

String choosenWord;
bool timerRunning2 = false;

class PainterScreen extends StatelessWidget {
// int i;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: ChooseOrDraw(),
                  flex: 2,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: textAndChat),
                        color: textAndChat
                        // color: Colors.blueAccent[100]
                        ),
                    child: ChatList(),
                  ),
                )
              ],
            ),
          ),
          //stack child 2 down
          stackChild('painter')
        ]),
      ),
    );
  }
}

class ChooseOrDraw extends StatefulWidget {
  @override
  _ChooseOrDrawState createState() => _ChooseOrDrawState();
}

class _ChooseOrDrawState extends State<ChooseOrDraw> {
  var subs;
  int curr = 90;
  int star = 90;

  @override
  Widget build(BuildContext context) {
    if (word != '*') //this is true when it should not be
    {
      if (curr > 1 && counter - 1 != guessersId.length) {
        if (!timerRunning2) {
          print('timer started');
          startTimer();
          timerRunning2 = true;
        }
        return Painter();
      } else {
        //curr=90;
        timerRunning2 = false;
        subs.cancel();
        return WordWas();
      }
    } else
      return ChooseWordDialog();
  }

  @override
  void dispose() {
    curr = 90;
    if (subs != null)
      subs.cancel(); //error caught by crashlytics   -- got undertesting fix
    timerRunning2 = false;
    super.dispose();
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: star),
      new Duration(seconds: 1),
    );
    subs = countDownTimer.listen(null);
    subs.onData((duration) {
      if (curr <= 1)
        setState(() {
          curr = star - duration.elapsed.inSeconds;
        });
      else
        curr = star - duration.elapsed.inSeconds;
    });
  }
}

Future<void> changeDen(String source) async {
  record = {
    'name': userNam,
    'beforeChangeDenId': denId,
    'beforeChangeDenName': players[playersId.indexOf(denId)],
    'round': round,
    'myIndex': playersId.indexOf(identity),
    'indexOfDenner': playersId.indexOf(denId),
    'word': word,
    'source': source,
    'guessersId': guessersId,
    'no. of guessers': guessersId.length
  };
  denChangeTrack = denChangeTrack + [record];
  word = '*';
  int s = playersId.indexOf(denId);
  if (s == players.length - 1) {
    s = 0;
    round = round + 1;
  } else
    s = s + 1;
  for (int k = 0; k < tempScore.length; k++) {
    tempScore[k] = 0;
  }

  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'den': players[s],
    'den_id': playersId[s],
    'xpos': {},
    'ypos': {},
    'word': '*',
    'length': 0,
    'wordChosen': false,
    'indices': [0],
    'pointer': 0,
    'guessersId': [],
    'tempScore': tempScore,
    'round': round,
    '$identity denChangeTrack': denChangeTrack
  });
}
