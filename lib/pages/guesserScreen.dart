import 'package:flutter/material.dart';
import 'package:scribbl/pages/guesser.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'selectRoom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wordWas.dart';
import 'WaitScreen.dart';
import 'package:quiver/async.dart';
bool timerRunning= false;
 final messageHolder= TextEditingController();
  List recentChat= chat;
  String message;
class GuesserScreen extends StatefulWidget {
  @override
  _GuesserScreenState createState() => _GuesserScreenState();
}
class _GuesserScreenState extends State<GuesserScreen> {
  int startG=20;
int currentG =20;
var subG;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                  color: Colors.white,
                     constraints: BoxConstraints.expand(),
                   child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ListView(
                         shrinkWrap: true,
                        // reverse: true,
                         //physics: ScrollPhysics()
                        primary: false,
                        // mainAxisAlignment: MainAxisAlignment.start,
                         //crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                         //Time_gusser(),
                         guessWaitShow(),
                         Container(
                   // constraints: BoxConstraints.expand(),
                    height: 150.0,
                   // width: 150.0,
                    color: Colors.grey[100],
                     child : Padding(
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

                                    if(m=='doodle123'){
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
                   Container(
                      color: Colors.white,
                      height: 60.0,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 6,
                                                      child: Container(
                              color: Colors.white,
                            //  width: 290.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
              
                                  

                                  controller: messageHolder,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
                
               onChanged: (mess) {
                 message=mess;
               },
               onEditingComplete: () {

                },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                             child: IconButton(icon: Icon(Icons.send, color: Colors.red[800],),
                            onPressed: (){
                              message =' $message ';
                              messageHolder.clear();
                              messageHolder.clearComposing();
                              if(message.indexOf(word)!=-1){
                                message = 'doodle123';
                              }

                               String newMessage = '$userNam]$message';                     
                               recentChat.add(newMessage);
                               //Navigator.pop(context);
                              sendMessage();
                            },
                            ),
                          )
                        ],
                      ),
                       )
                       ],),
                     )
        
      ),
            ),
          ),
    );
  }

  Future<void> sendMessage() async{
    Firestore.instance.collection('rooms').document(documentid).updateData({'chat':recentChat});
  }

  Widget guessWaitShow(){
    if(word!=' ')
      {
        if(currentG>4)
          {
            if(!timerRunning)
            {
              startTimer();
              timerRunning=true;
            }
            
              return Guesser();
          }
          
         else
          return WordWas();
      }
        else
          return WaitScreen();

  }
  void startTimer() {
  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: startG),
    new Duration(seconds: 1),
  );

  subG = countDownTimer.listen(null);
  subG.onData((duration) {
    if(currentG<5)
    setState(() { currentG = startG - duration.elapsed.inSeconds; });
    else
    currentG = startG - duration.elapsed.inSeconds;
  });

  subG.onDone(() {
    timerRunning=false;
    currentG=20;
    print("Done");   
    word=' ';
    pointsG=[]; 
    subG.cancel();
  });
}
@override
void dispose()
{
  subG.cancel();
  timerRunning=false;
  currentG=20;
  super.dispose();
}
}