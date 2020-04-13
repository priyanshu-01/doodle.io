import 'package:flutter/material.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painter.dart';
import 'room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chooseWord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
String choosenWord;
bool timerRunning2= false;
class PainterScreen extends StatefulWidget {
  @override
  _PainterScreenState createState() => _PainterScreenState();
}
class _PainterScreenState extends State<PainterScreen> {
   var subs;
  int curr = 20;
int star= 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
                      child: Container(
              //constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                chooseOrDraw(),
               Flexible(
                    child: FractionallySizedBox(
                    heightFactor: 1.0,
                     // constraints: BoxConstraints.expand(),
              //  height: 200.0,
                     // width: 150.0,
               // color: Colors.orange[100],
                   child : Container(
                    color: Colors.white,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ListView.builder(
                             //shrinkWrap: true,
                             reverse: true,                  
                             itemCount: chat.length,
                             itemBuilder: (BuildContext context, int index) {
                                   //print('got new message');
                                   String both = chat[chat.length-1-index];
                                   String n = both.substring(0, both.indexOf(']') );
                                   String m = both.substring( both.indexOf(']')+1 );

                                    if(m==' doodle123 '){
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('$n Guessed', style: TextStyle(color: Colors.green,
                                        fontSize: 14.0
                                        
                                        ),),
                                      );

                                    }

                                  else return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('$n', style: GoogleFonts.roboto(color: Colors.red[800])),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                       child: Container(
                                      
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('$m', style: TextStyle(fontSize: 12.0)),
                                      )),
                                  )
                                   ],);
                        },
                       ),
                     ),
                   ),

                     ),
                )
                


              ],),
        
      ),
          ),
    );
  }

  Widget chooseOrDraw(){
    if(curr>4)
    {
                           if(word!=' ')
                              {
                                if(!timerRunning2)
                                {
                                  print('bloc executed');
                                  startTimer();
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
    pointsD=[];
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
  word=' ';
   int s= playersId.indexOf(denId);
   if(s==players.length-1){s=0;}
    else s=s+1;
   await Firestore.instance.collection('rooms').document(documentid).updateData({'den':players[s],
   'den_id':playersId[s],
   'xpos':{},'ypos':{},'word':' ','length':0,'wordChosen': false,
   });
   //startTimer();
 }  