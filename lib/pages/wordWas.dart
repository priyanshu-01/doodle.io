import 'package:flutter/material.dart';
import 'package:scribbl/pages/painterScreen.dart';
import 'room.dart';
import 'package:quiver/async.dart';
import 'selectRoom.dart';
import 'package:google_fonts/google_fonts.dart';
class WordWas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  wordWasContent();
  }
}
class WordWas2 extends StatefulWidget {
  @override
  _WordWas2State createState() => _WordWas2State();
}

class _WordWas2State extends State<WordWas2> {
   int current=5;
int start=5;
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
    return wordWasContent();
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
    sub.cancel();
    if(denId!=identity)
    word='*';
    else{
      word='*';
      changeDen();
    }
    print("Done_timer");    
    //  changeDen();
  });
}
}
Widget wordWasContent(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        flex:1,
        child: 
       // Text('The word was $word')
        Text('Word was $word',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 25.0),
        ),),
      Flexible(
        flex:1,
          child: Container(
          child: Center(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (_,int a){
                String name= players[a];
                int score=tempScore[a];
                return FractionallySizedBox(
                  widthFactor: 0.7,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:4.0),
                                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    Text('$name',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 20.0)),
                    //Text(':',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 20.0)),
                    Text('+ $score',
                    style: GoogleFonts.notoSans(color: (score==0)?Colors.red[800]:Colors.green[600], fontSize: 20.0))
                  ],),
                                    ),
                );
              }),
          ),
        ),
      )
    ],
  );
}