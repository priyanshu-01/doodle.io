import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'painterScreen.dart';
import 'wordWas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
class PainterView extends StatefulWidget {
  @override
  _PainterViewState createState() => _PainterViewState();
}

class _PainterViewState extends State<PainterView> {
  var sub;
 int current =95;
int start=95;
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
    if(current>5)
    return PainterScreen();
    else return WordWas();
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
    print("Done");    
      changeDen();
    sub.cancel();
    
  });
}

}
Future<void> changeDen()async{
   int s= playersId.indexOf(denId);
   if(s==players.length-1){s=0;}
    else s=s+1;
   await Firestore.instance.collection('rooms').document(documentid).updateData({'den':players[s],
   'den_id':playersId[s],
   'xpos':{},'ypos':{},'word':' ','length':0,'wordChosen': false,
   });
   //startTimer();
 }