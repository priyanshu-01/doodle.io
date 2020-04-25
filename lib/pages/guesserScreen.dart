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
import 'package:bubble/bubble.dart';
bool timerRunning= false;
 final messageHolder= TextEditingController();
  List recentChat= chat;
  String message;
class GuesserScreen extends StatefulWidget {
  @override
  _GuesserScreenState createState() => _GuesserScreenState();
}
class _GuesserScreenState extends State<GuesserScreen> {
  int startG=95;
int currentG =95;
var subG;
  @override
  Widget build(BuildContext context) {
    recentChat= chat;
    return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                  color: Colors.white,
                     constraints: BoxConstraints.expand(),
                   child: Padding(
                       padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0),
                       child: Column(
                        // shrinkWrap: true,
                        // reverse: true,
                         //physics: ScrollPhysics()
                        //primary: false,
                        // mainAxisAlignment: MainAxisAlignment.start,
                         //crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                         //Time_gusser(),
                         Flexible(
                           flex: 7,
                           child: guessWaitShow()),
                           SizedBox(height: 5.0,),
                         Flexible(
                           flex: 4,
                         child: FractionallySizedBox(
                           heightFactor: 1.0,
                        child: Container(
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
                   // constraints: BoxConstraints.expand(),
                   // height: 250.0,
                   // width: 150.0,
                     child : Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: chatList(),
                     ),
                   ),
                         ),
                         ),
                         SizedBox(height: 5.0,),
                   Container(
                     color: Colors.white,
                        height: 70.0,
                   child: Padding(
                     padding: const EdgeInsets.only(left:12.0, right: 12.0, bottom: 8.0),
                     child: TextField(
            
                       decoration: InputDecoration(
                         border: OutlineInputBorder(

                           borderRadius: BorderRadius.circular(25.0),
                           borderSide: BorderSide(color: Colors.black)
                         ),
                         focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          // width: 16.0,style: BorderStyle.solid
                        ),

                      ),

                         suffix: IconButton(
                          //  backgroundColor: Colors.black,
                          //   mini: true,
                          //  color: Colors.blue,
                           icon: Icon(
                             Icons.send, color: Colors.black,
                             size: 30.0,),
                     onPressed: (){
                   message =' $message ';
                   if(message!='  '){
                     messageHolder.clear();
                   messageHolder.clearComposing();
                   if(message.indexOf(word)!=-1){
                     message = 'd123';
                   }
                    String newMessage = '$identity[$userNam]$message';                     
                    recentChat.add(newMessage);
                    //Navigator.pop(context);
                   sendMessage();
                    }
                    message='';
                   
                     },
                     ),
                     prefix: SizedBox(width: 15.0,),
                         focusColor: Colors.white
                       ),
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
    if(word!='*')
      {
        if(currentG>4)
          {
            if(!timerRunning)
            {
          //  startTimer();
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
    word='*';
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
Widget chatList(){
  return ListView.builder(
                             //shrinkWrap: true,
                            reverse: true,                  
                             itemCount: chat.length,
                             itemBuilder: (BuildContext context, int index) {
                                   //print('error below');
                                   String both = chat[chat.length-1-index];
                                   String i= both.substring(0,both.indexOf('['));
                                   String n = both.substring(both.indexOf('[')+1, both.indexOf(']') );
                                   String m = both.substring( both.indexOf(']')+1 );
                                    if(m=='d123'){
                                      return Center(
                                        child: Padding(
                                          
                                          padding: const EdgeInsets.all(1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                     border: Border.all(
                                      width: 1.0,
                                      color: Colors.black
                        
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white
                      ),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(15.0,7.0,15.0,7.0),
                                              child: Text('$n Guessed', style: TextStyle(color: Colors.black,
                                              fontSize: 14.0
                                              
                                              ),),
                                            ),
                                          ),
                                        ),
                                      );

                                    }
                                  else return Column(
                                    
                                crossAxisAlignment: (identity.toString()==i)?CrossAxisAlignment.end:CrossAxisAlignment.start,
                                children: <Widget>[
                                  nameOfOthers(i,n),
                                  (i==identity.toString())?
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Bubble(
                                      nip: BubbleNip.rightTop,
                                      color: Colors.white,
                                      shadowColor: Colors.black,
                                      elevation: 5.0,

                      //                 decoration: BoxDecoration(
                      //                border: Border.all(
                      //                 width: 1.0,
                      //                 color: Colors.black
                      //                // color: Colors.grey[300]
                      //   ),
                      //   borderRadius: BorderRadius.circular(25.0),
                      //   color: Colors.white
                      // ),
                                        child: Padding(
                                     padding: const EdgeInsets.fromLTRB(6.0,4.0,6.0,4.0),
                                     child: Text('$m', style: GoogleFonts.ubuntu(fontSize: 12.0)),
                                        )),
                                  ):
                                   Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Bubble(
                                      nip: BubbleNip.leftTop,
                                      color: Colors.white,
                                      shadowColor: Colors.black,
                                      elevation: 5.0,

                                                                          child: Padding(
                                       padding: const EdgeInsets.fromLTRB(6.0,4.0,6.0,4.0),
                                       child: Text('$m', style: GoogleFonts.ubuntu(fontSize: 12.0)),
                                      ),
                                    ),
                                  )
                                   ],);
                        },
                       );
}
Widget nameOfOthers(String iden, String nam){
  if(iden==identity.toString())
  return Container();
  else
  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('$nam', style: GoogleFonts.quicksand(color: Colors.black)),
                                  );

}