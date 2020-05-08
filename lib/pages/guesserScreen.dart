import 'dart:ui';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

bool timerRunning = false;
final messageHolder = TextEditingController();
List recentChat = chat;
String message;
bool madeIt = false;
double guessTotalLength;
double guessCanvasLength;
bool keyboardState;
Color textAndChat = Color(0xFFFFF5EE);

class GuesserScreen extends StatefulWidget {
  @override
  _GuesserScreenState createState() => _GuesserScreenState();
}

class _GuesserScreenState extends State<GuesserScreen> {
  //Color textAndChat= Color(0xFFECC5C0);
  int startG = 90;
  int currentG = 90;
  var subG;
  int score = 0;
  @override
  void initState() {
    super.initState();
    keyboardState = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        keyboardState = visible;
        if (keyboardState)
          effectiveLength = guessTotalLength * 0.6;
        else
          effectiveLength = guessTotalLength;
        print(keyboardState);
        print('effective length: $effectiveLength');
        guessCanvasLength = (((effectiveLength - 70) * 0.6) * (7 / 8));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //textAndChat=Colors.pink[100];

    recentChat = chat;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
              color: Colors.white,
              // color: textAndChat,
              constraints: BoxConstraints.expand(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Flexible(flex: 6, child: guessWaitShow()),

                    Flexible(
                      flex: 4,
                      child: FractionallySizedBox(
                        heightFactor: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: textAndChat),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0)),
                              color: textAndChat
                              //color: Color(0xFFFABBB9),
                              // color: Colors.blueAccent[100]
                              ),
                          // constraints: BoxConstraints.expand(),
                          // height: 250.0,
                          // width: 150.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: chatList(),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: 5.0,),
                    Container(
                      color: textAndChat,
                      height: 70.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 8.0),
                        child: TextField(
                          cursorColor: Color(0xFF1A2F77),

                          // selectionHeightStyle: BoxHeightStyle.

                          decoration: InputDecoration(
                              //  fillColor: Colors.pink,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide:
                                    new BorderSide(color: Color(0xFF16162E)
                                        // color: Colors.black,
                                        // width: 16.0,style: BorderStyle.solid
                                        ),
                              ),
                              suffix: Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: IconButton(
                                  //  backgroundColor: Colors.black,
                                  //   mini: true,
                                  //  color: Colors.blue,
                                  icon: Icon(
                                    Icons.send,
                                    //color: Color(0xFF16162E),
                                    // color: Color(0xFFFF4893),
                                    color: Color(0xFF1A2F77),
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    message = ' $message ';
                                    if (message != '  ') {
                                      messageHolder.clear();
                                      messageHolder.clearComposing();
                                      if (message.indexOf(word) != -1) {
                                        message = 'd123';
                                        if (madeIt == false) {
                                          calculateScore();
                                          updateScore(); //and guesses number also
                                          //painter score gets updated in updateScore
                                        }
                                      }
                                      String newMessage =
                                          '$identity[$userNam]$message';
                                      recentChat.add(newMessage);
                                      //Navigator.pop(context);
                                      sendMessage();
                                    }
                                    message = '';
                                  },
                                ),
                              ),
                              prefix: SizedBox(
                                width: 15.0,
                              ),
                              focusColor: Colors.white),
                          controller: messageHolder,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.newline,

                          onChanged: (mess) {
                            message = mess;
                          },
                          onEditingComplete: () {},
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'chat': recentChat});
  }

  Future<void> updateScore() async {
    guesses = guesses + 1;
    int place = playersId.indexOf(identity);
    tempScore[place] = score;
    int previousScore = finalScore[place];
    int newScore = previousScore + score;
    finalScore[place] = newScore;
    int ind = playersId.indexOf(denId);
    int sum = 0;
    for (int k = 0; k < tempScore.length; k++) {
      if (k == ind) continue;
      sum = sum + tempScore[k];
    }
    sum = sum ~/ (tempScore.length - 1);
    tempScore[ind] = sum;
    finalScore[ind] = finalScore[ind] + sum;
    madeIt = true;
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({
      'tempScore': tempScore,
      'finalScore': finalScore,
      'guesses': guesses
    });
  }

  void calculateScore() {
    //1 time
    int s1;
    int currentTime = currentG - 5;
    s1 = (currentTime ~/ 10) + 1;
    s1 = s1 * 10;
    int s2;
    double per = (a['guesses'] / a['counter']) * 100;
    s2 = per.round();
    s2 = 100 - s2;
    score = s1 + s2;
    score = score ~/ 2;
    //2 percentage of people who have already guessed

    //claculate score for denner
  }

  Widget guessWaitShow() {
    if (word != '*') {
      if (currentG >= 1 && counter - 1 != guesses) {
        if (!timerRunning) {
          if (keyboardState)
            effectiveLength = guessTotalLength * 0.6;
          else
            effectiveLength = guessTotalLength;
          guessCanvasLength = (((effectiveLength - 70) * 0.6) * (7 / 8));
          madeIt = false;
          startTimer();
          timerRunning = true;
        }
        return Guesser();
      } else {
        // if (counter - 1 != guesses)
        // {
        //    return WordWas();
        // }
        // else {
          subG.cancel();
          currentG = 90;
          pointsG = [];
          timerRunning = false;
          return WordWas();
        //}
      }
    } else
      return WaitScreen();
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: startG),
      new Duration(seconds: 1),
    );

    subG = countDownTimer.listen(null);
    subG.onData((duration) {
      if (currentG <= 1)
        setState(() {
          currentG = startG - duration.elapsed.inSeconds;
        });
      else
        currentG = startG - duration.elapsed.inSeconds;
    });

    // subG.onDone(() {
    //   // timerRunning = false;
    //   // print("Done");
    //   //  word = '*';
      
    //   // subG.cancel();
    //   // currentG=95;
    // });
  }

  @override
  void dispose() {
    word = '*';
    subG.cancel();
    currentG=90;
    timerRunning = false;
    super.dispose();
  }
}

Widget chatList() {
  return ListView.builder(
    //shrinkWrap: true,
    reverse: true,
    itemCount: chat.length,
    itemBuilder: (BuildContext context, int index) {
      //print('error below');
      String both = chat[chat.length - 1 - index];
      String i = both.substring(0, both.indexOf('['));
      String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
      String m = both.substring(both.indexOf(']') + 1);
      if (m == 'd123') {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.black),
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 7.0, 15.0, 7.0),
                child: Text(
                  '$n Guessed',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
              ),
            ),
          ),
        );
      } else
        return Column(
          crossAxisAlignment: (identity.toString() == i)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            (i == identity.toString())
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Bubble(
                        nip: BubbleNip.rightTop,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 2.0,

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
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                          child: Column(
                            children: [
                              nameOfOthers(i, n),
                              Text('$m',
                                  style: GoogleFonts.ubuntu(fontSize: 10.0)),
                            ],
                          ),
                        )),
                  )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Bubble(
                      nip: BubbleNip.leftTop,
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nameOfOthers(i, n),
                            Text('$m',
                                style: GoogleFonts.ubuntu(fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        );
    },
  );
}

Widget nameOfOthers(String iden, String nam) {
  if (iden == identity.toString())
    return Container(
      height: 0,
      width: 0,
    );
  else
    return Text('$nam',
        style: GoogleFonts.roboto(color: Colors.black, fontSize: 12.0));
}
