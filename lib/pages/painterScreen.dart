import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painter.dart';
import 'room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chooseWord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
import 'guesserScreen.dart';
import 'guesserScreen.dart';
String choosenWord;
bool timerRunning2= false;
bool madeIt2=false;

class PainterScreen extends StatefulWidget {
  @override
  _PainterScreenState createState() => _PainterScreenState();
}
class _PainterScreenState extends State<PainterScreen> {
   var subs;
  int curr = 95;
int star= 95;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
                      child: Container(
                        color: Colors.white,
              //constraints: BoxConstraints.expand(),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Flexible(child: chooseOrDraw(),
                flex: 7,),
               Flexible(
                 flex: 5,
                    child: Container(

                     decoration: BoxDecoration(
                                      border: Border.all(
                                       width: 1.0,
                                       color: textAndChat
                         
                         ),
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
                


              ],),
        
      ),
          ),
    );
  }
  Widget chooseOrDraw(){
    if(word!='*')//this is true when it should not be
    {
                           if(curr>4  && counter-1!=guesses)
                              {
                                if(!timerRunning2)
                                {
                                  madeIt2=false;
                                  print('bloc executed');
                                //  startTimer();
                                  timerRunning2=true;
                                }
                                return Painter();
                              }
                            
                            else
                            {
                              if(madeIt2==false)
                              updateDennerScore();
                              if(counter-1!=guesses)
                              return WordWas();
                              else
                              { 
                                timerRunning2=false;
                                subs.cancel();
                                return WordWas2();
                              }
                              
                            }
    }
    else
    return  ChooseWordDialog();
                      
  }
   void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: star),
    new Duration(seconds: 1),
  );
  subs = countDownTimer.listen(null);
  subs.onData((duration) {
    if(curr<5)
    setState(() { curr = star - duration.elapsed.inSeconds; });
    else
    curr = star - duration.elapsed.inSeconds;
  });
  subs.onDone(() {
    timerRunning2=false;
    print("Done_painterView");    
    subs.cancel();
      changeDen();
  });
}
void dispose()
{
  subs.cancel();
  timerRunning2=false;
  if(denId==identity)
  changeDen();
  super.dispose();
}
}
Future<void> changeDen()async{
  word='*';
   int s= playersId.indexOf(denId);
   if(s==players.length-1){
     s=0;
   round = round+1;
   }
    else s=s+1;
    for(int k=0;k<tempScore.length;k++){
      tempScore[k]=0;
    }

   await Firestore.instance.collection('rooms').document(documentid).updateData({'den':players[s],
   'den_id':playersId[s],
   'xpos':{},'ypos':{},'word':'*','length':0,'wordChosen': false,
   'indices': [0], 'pointer': 0, 'guesses':0, 'tempScore':tempScore,'round':round
   });
   //startTimer();
 }  
 Future<void> updateDennerScore() async{
   madeIt2=true;
   List tScore =List();
   List fScore= finalScore;
   tScore=tempScore;
   int ind= playersId.indexOf(identity);
   int sum=0;
   for(int k=0;k<tempScore.length;k++){
     if(k==ind)
     continue;
      sum=sum+tempScore[k];
   }
   sum=sum~/(tempScore.length-1);
   sum=(sum*1.5).round();
   tScore[ind]= sum;
   int previousScore= finalScore[ind];
   fScore[ind]= previousScore+sum;
    await Firestore.instance.collection('rooms').document(documentid).updateData({
      'tempScore':tScore,
      'finalScore':fScore
   });

 }