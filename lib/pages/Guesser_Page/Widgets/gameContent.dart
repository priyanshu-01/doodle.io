import 'package:flutter/material.dart';
import 'package:scribbl/pages/guesser.dart';
import '../../room/room.dart';
import '../../wordWas.dart';
import '../../WaitScreen.dart';
import 'package:quiver/async.dart';
import '../guesserScreen.dart';
class GuessWaitShow extends StatefulWidget {
  @override
  _GuessWaitShowState createState() => _GuessWaitShowState();
}

class _GuessWaitShowState extends State<GuessWaitShow> {
  int startG = 92;
  int currentG = 92;
  var subG;
  @override
  Widget build(BuildContext context) {
    if (word != '*') {
      if (currentG > 3 && counter - 1 != guessersId.length) {
        if (!timerRunning || tempDenId != denId) {
          tempDenId = denId;
          startTimer();
          timerRunning = true;
        }
        return Guesser();
      } else {
        timerZero();
        return WordWas();
      }
    } else {
      if (currentG != 92) {
        print('timerStoppedForcefully ');
        timerZero();
      }
      return WaitScreen();
    }
  }

  void timerZero() {
    print('timerZero called');
    subG.cancel();
    currentG = 92;
    pointsG = [];
    timerRunning = false;
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: startG),
      new Duration(seconds: 1),
    );

    subG = countDownTimer.listen(null);
    subG.onData((duration) {
      if (currentG <= 3)
        setState(() {
          currentG = startG - duration.elapsed.inSeconds;
        });
      else
        currentG = startG - duration.elapsed.inSeconds;
    });

    subG.onDone(() {
      print('subG.onDone() called');
      timerRunning = false;
      //word = '*';
      pointsG = [];
      subG.cancel();
      currentG = 92;
    });
  }

  @override
  void dispose() {
    word = '*';
    if (subG != null) subG.cancel();
    currentG = 92;
    timerRunning = false;
    super.dispose();
  }
}