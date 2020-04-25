import 'package:flutter/material.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painter.dart';
import 'room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chooseWord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
import 'guesserScreen.dart';
String choosenWord;
bool timerRunning2= false;
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
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
              //constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                Flexible(child: chooseOrDraw(),
                flex: 7,),
               Flexible(
                 flex: 5,
                    child: FractionallySizedBox(
                    heightFactor: 1.0,
                     // constraints: BoxConstraints.expand(),
              //  height: 200.0,
                     // width: 150.0,
               // color: Colors.orange[100],
                   child : Container(

                    decoration: BoxDecoration(
                                       border: Border.all(
                                        width: 1.0,
                                       // color: Colors.grey[300]
                          
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                          //color: Colors.white
                           color: Color(0xFF4BCFFA),
                          // color: Colors.blueAccent[100]
                        ),
                     child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: chatList(),
                     ),
                   ),

                     ),
                )
                


              ],),
        
      ),
                      ),
          ),
    );
  }

  Widget chooseOrDraw(){
    if(curr>4)
    {
                           if(word!='*')
                              {
                                if(!timerRunning2)
                                {
                                  print('bloc executed');
                                 // startTimer();
                                  timerRunning2=true;
                                }
                                
                                return Painter();
                              }
                            
                            else
                            return ChooseWordDialog();
    }
    else
    return WordWas();
                      
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
    curr=20;
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
  curr=20;
  super.dispose();
}
}
Future<void> changeDen()async{
  word='*';
   int s= playersId.indexOf(denId);
   if(s==players.length-1){s=0;}
    else s=s+1;
   await Firestore.instance.collection('rooms').document(documentid).updateData({'den':players[s],
   'den_id':playersId[s],
   'xpos':{},'ypos':{},'word':'*','length':0,'wordChosen': false,
   'indices': [0], 'pointer': 0
   });
   //startTimer();
 }  