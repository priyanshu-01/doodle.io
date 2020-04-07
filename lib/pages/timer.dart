import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'room.dart';
import 'selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
int current=10;
int start=10;
class Time_denner extends StatefulWidget {
  @override
  _Time_dennerState createState() => _Time_dennerState();
}

class _Time_dennerState extends State<Time_denner> {
  @override
  void initState(){
    startTimer();
    super.initState();
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

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { current = start - duration.elapsed.inSeconds; });
  });

  sub.onDone(() {
    print("Done");    
      changeDen();
    sub.cancel();
    
  });
}
 
}
Future<void> changeDen()async{
   int s= players.indexOf(denner);
   if(s==players.length-1){s=0;}
    else s=s+1;
   await Firestore.instance.collection('rooms').document(documentid).updateData({'den':players[s],
   'xpos':{},'ypos':{},'word':' ','length':0,'wordChosen': false,
   });
   //startTimer();
 }


class Time_gusser extends StatefulWidget {
  @override
  _Time_gusserState createState() => _Time_gusserState();
}

class _Time_gusserState extends State<Time_gusser> {
@override
  void initState(){
    startTimer();
    super.initState();
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

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { current = start - duration.elapsed.inSeconds; });
  });

  sub.onDone(() {
    print("Done");
    // current=10;
    // start=10;
    sub.cancel();
    
  });
}
}


