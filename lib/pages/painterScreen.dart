import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painter.dart';
import 'room/room.dart';
import 'chooseWord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
import 'guesserScreen.dart';
String choosenWord;
bool timerRunning2 = false;
//bool madeIt2=false;
class PainterScreen extends StatefulWidget {
  @override
  _PainterScreenState createState() => _PainterScreenState();
}

class _PainterScreenState extends State<PainterScreen> {
int i;
  var subs;
  int curr = 90;
  int star = 90;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
          Container(
            color: Colors.white,
            //constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: chooseOrDraw(),
                  flex: 8,
                ),
                Flexible(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: textAndChat),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                        // color: Colors.white
                        //  color: Color(0xFF4BCFFA),
                        color: textAndChat
                        // color: Colors.blueAccent[100]
                        ),
                    child: chatList(),
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

  Widget chooseOrDraw() {
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
        timerRunning2 = false;
        subs.cancel();
        curr = 90;
        return WordWas();
      }
    } else
      return ChooseWordDialog();
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
    // subs.onDone(() {
    //   timerRunning2 = false;
    //   print("Done_painterView");
    //   subs.cancel();
    //  // changeDen();
    // });
  }

  void dispose() {
    if(subs!=null)
    subs.cancel();                //error caught by crashlytics   -- got undertesting fix
    timerRunning2 = false;
    super.dispose();
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
    'word':word,
    'source':source,
    'guessersId': guessersId,
    'no. of guessers': guessersId.length
  };
  denChangeTrack=denChangeTrack+[record];
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
