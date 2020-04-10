import 'package:flutter/material.dart';
import 'guesserScreen.dart';
import 'wordWas.dart';
import 'package:quiver/async.dart';
class GuesserView extends StatefulWidget {
  @override
  _GuesserViewState createState() => _GuesserViewState();
}
class _GuesserViewState extends State<GuesserView> {
int current =95;
int start=95;
  @override
  void initState(){
    startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(current>5)
    return GuesserScreen();
    else return WordWas();
  }
  void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: start),
    new Duration(seconds: 1),
  );

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    if(current ==5)
    setState(() { current = start - duration.elapsed.inSeconds; });
    else
    current = start - duration.elapsed.inSeconds;

  });

  sub.onDone(() {
    print("Done");    
      //changeDen();
    sub.cancel();
  });
}
}