import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'selectRoom.dart';
class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}
class _TimeState extends State<Time> {
  int current=90;
int start=90;
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
      child: Text('$current', style: GoogleFonts.lexendGiga(),),
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
class TimeAndWord extends StatefulWidget {
  @override
  _TimeAndWordState createState() => _TimeAndWordState();
}

class _TimeAndWordState extends State<TimeAndWord> {
  Color timerColor;
int current=90;
int start=90;
List<int> places =new List();
List<int> revealed = List();
int counter=0;
int q=0,w=0,e=0,r=0;
  var sub;
  @override
  void initState(){
    timerColor=Colors.green[600];
    places= getClues();
    initialiseTime();
    startTimer();
    super.initState();
  }
  @override
  void dispose(){
    sub.cancel();
    super.dispose();
  }
    void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: start),
    new Duration(seconds: 1),
  );
  sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(() { current = start - duration.elapsed.inSeconds; 
    if(current<20){
      timerColor=(current%2==0)?Colors.red[800]:Colors.white;
    }});
    if(current ==q){
      revealed.add(places[counter++]);
    }
    else if(current ==w){
      if(places.length>1){
        revealed.add(places[counter++]);
      }
    }
        else if(current ==e){
      if(places.length>2){
        revealed.add(places[counter++]);
      }
    }
        else if(current ==r){
      if(places.length>3){
        revealed.add(places[counter++]);
      }
    }
  });

  sub.onDone(() {
    print("Done_timer");    
    //  changeDen();
    sub.cancel();
    
  });
}
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      //Text('$denner',style: GoogleFonts.notoSans(),),
       (guessersImage.indexOf( playersImage[playersId.indexOf(identity)] )==-1)?
      Icon(Icons.access_alarm,color: timerColor,):
      Container(
        decoration: BoxDecoration(
          color: Colors.green[700],
          border: Border.all(
            color: Colors.green[700]
          ),
          borderRadius: BorderRadius.circular(30.0)
        ),
        child:Icon(Icons.done, color: Colors.white,)
      ),
      
      Text('$current', style: GoogleFonts.lexendGiga(),),
      wordHint()
    ],);
  }

  Widget wordHint(){
    
          return Flexible(
            child: FractionallySizedBox(
              widthFactor: word.length/17,
              child: Container(
                //alignment: Alignment.bottomCenter,
                //color: Colors.orange[50],
                child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: word.length,
          itemBuilder: (_,int h){
              if(word.indexOf(' ')==h){
                return Container(
              alignment: Alignment.center,
              child: Text('  ',style: TextStyle(fontSize: 15.0),));
              }
              else
                {
                  if(revealed.indexOf(h)==-1){
                        return Container(
             alignment: Alignment.center,
              child: Text('_ ',style: TextStyle(fontSize: 15.0),));
                  }
                  else
                  {
                    String rev= word[h];
                    return Container(
             alignment: Alignment.center,
              child: Text('$rev ',style: TextStyle(fontSize: 15.0),));
                  }
                }
          }),
              ),
      ),
    );
  }

  List<int> getClues(){
    List<int> place = List();
    int l= word.length;
    int div= l~/4;
    int i;
    double r;
    int k;
    for(i=0;i<div;i++){
      r= Random().nextDouble();
      r=(r*4) ;
      k=r.toInt();
      if(word[(i*4)+k]!=' ')
      place.add( (i*4)+k);
      else
      place.add( (i*4)+k+1);
      }
      if(l%4!=0){
        int rem;
        rem= l%4;
      r= Random().nextDouble();
      r=(r*rem) ;
      k=r.toInt();
      if(word[(div*4)+k]!=' ')
      place.add( (div*4)+k);
      else
       place.add( (div*4)+k+1);
      }
      return place;
  }
  void initialiseTime(){
    int len= word.length;
      if(len<=4){
        q=60;
      }
      else if(len<=8){
        q=70;
        w=45;
      }
      else if(len<=12){
        q=75;
        w=50;
        e=30;
      }
      else{
        q=85;
        w=65;
        e=35;
        r=15;
      }
  }
}
