import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'room.dart';

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}
class _TimeState extends State<Time> {
  int current=15;
int start=15;
  var sub;
  @override
  void initState(){
    startTimer();
    super.initState();
  }
  @override
  void dispose(){
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$current'),
    );
  }
  void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: start),
    new Duration(seconds: 1),
  );

  sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { current = start - duration.elapsed.inSeconds; });
  });

  sub.onDone(() {
    print("Done_timer");    
    //  changeDen();
    sub.cancel();
    
  });
}
 
}


class WordHint extends StatefulWidget {
  @override
  _WordHintState createState() => _WordHintState();
}

class _WordHintState extends State<WordHint> {
  int c=90,s=90;
  @override
  Widget build(BuildContext context) {
    return Container(
     // height: 50.0,
      width: 100.0,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: word.length,
        itemBuilder: (_,int h){
          return Text('_ ',style: TextStyle(fontSize: 25.0),);
        }),
      
    );
  }
}
