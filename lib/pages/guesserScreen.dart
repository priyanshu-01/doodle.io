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
import 'package:achievement_view/achievement_view.dart';

bool timerRunning = false;
final messageHolder = TextEditingController();
String message = '';
bool madeIt = false;
double guessCanvasLength;
bool keyboardState;
String newMessage;
Color textAndChat = Color(0xFFFFF1E9);
int score = 0;
String tempDenId;
AnimationController controlAvatar;

class GuesserScreen extends StatefulWidget {
  @override
  _GuesserScreenState createState() => _GuesserScreenState();
}

class _GuesserScreenState extends State<GuesserScreen> {
  //Color textAndChat= Color(0xFFECC5C0);
  final FocusNode fn = FocusNode();
  int startG = 90;
  int currentG = 90;
  var subG;

  @override
  void initState() {
    guessCanvasLength = (((effectiveLength * 0.6) - 50) * (7 / 8));
    super.initState();
    keyboardState = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        keyboardState = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (tempDenId != denId && word != '*') {
    //   controlAvatar.forward(from: 0.0);
    //   tempDenId = denId;
    // }
    //  if (tempDenId != denId &&tempDenId!=null && word == '*') {
    // //  controlAvatar.reset();
    //   controlAvatar.value= 0.0;
    //   // controlAvatar.forward(from: 0.0);
    //   // tempDenId = denId;
    // }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(children: <Widget>[
            Container(
                color: Colors.white,
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: <Widget>[
                    Flexible(flex: 6, child: guessWaitShow()),
                    Container(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 8.0, 0.0, 10.0),
                              child: Image(
                                image: AssetImage('assets/icons/gift.gif'),
                              )),
                          Container(
                            width: totalWidth * 0.7,
                            color: Colors.white,
                            height: 50.0,
                            child: TextField(
                              style: GoogleFonts.ubuntu(
                                fontSize: 20.0,
                                //fontWeight: FontWeight.bold
                              ),
                              focusNode: fn,
                              cursorColor: Color(0xFF1A2F77),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color(0xFFFF4893),
                                  )),
                                  hintText: 'Type Here',
                                  focusColor: Colors.white),
                              controller: messageHolder,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.newline,
                              onChanged: (mess) {
                                setState(() {
                                  message = mess;
                                });
                              },
                              onEditingComplete: () {},
                            ),
                          ),
                          (message == '')
                              ? (keyboardState)
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30.0,
                                        color: Color(0xFFFF4893),
                                      ),
                                      onPressed: () {
                                        fn.unfocus();
                                        // FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 30.0,
                                        color: Color(0xFFFF4893),
                                      ),
                                      onPressed: () {
                                        fn.requestFocus();
                                      },
                                    )
                              : IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    //color: Color(0xFF16162E),
                                    color: Color(0xFFFF4893),
                                    //  color: Color(0xFF1A2F77),
                                    //   color: Color(0xFFA74AC7),
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    message = ' $message ';
                                    if (message != '  ') {
                                      messageHolder.clear();
                                      messageHolder.clearComposing();
                                      String lowerCase = message.toLowerCase();
                                      if (lowerCase.indexOf(word) != -1) {
                                        message = 'd123';
                                        if (guessersId.indexOf(identity) ==
                                            -1) {
                                          if (guessersId.length <
                                              counter - 2) showPopup(context);
                                          calculateScore();
                                          updateGuesserId();
                                        }
                                      } else {
                                        newMessage =
                                            '$identity[$userNam]$message';
                                        chat.add(newMessage);
                                        //Navigator.pop(context);
                                        sendMessage();
                                      }
                                    }
                                    // this step might give error
                                    message = '';
                                    fn.unfocus();
                                  },
                                ),
                        ],
                      ),
                    ),
                    (keyboardState)
                        ? Container()
                        : Flexible(
                            flex: 4,
                            child: FractionallySizedBox(
                              heightFactor: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: textAndChat),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0)),
                                    color: textAndChat
                                    //  color: Color(0xFFFFF1E9)
                                    //color: Color(0xFFFABBB9),
                                    // color: Colors.blueAccent[100]
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: chatList(),
                                ),
                              ),
                            ),
                          ),
                    //SizedBox(height: 5.0,),
                  ],
                )),
            Container(
              // color: Colors.red,
              // constraints: BoxConstraints.expand(),
              height: guessCanvasLength,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    //color: Colors.blue,
                    height: guessCanvasLength - 10,
                    width: 50.0,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: guessersId.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          child:
                           (playersId.indexOf(
                                  guessersId[index]
                                )==-1)?Container():
                           CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: NetworkImage(
                              playersImage[
                                playersId.indexOf(
                                  guessersId[index]
                                )
                              ]
                              
                              ),
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedAvatar()
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  void showPopup(context) {
    AchievementView(context,
        title: "Bingo!",
        subTitle: '',
        isCircle: true,
        icon: Icon(Icons.done),
        textStyleTitle: TextStyle(color: Colors.white, fontSize: 17.0),
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        color: Colors.green[700])
      ..show();
  }

  Future<void> updateGuesserId() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({
      '$identity': '$denId $round',
    });
  }

  void calculateScore() {
    //1 time
    int s1;
    int currentTime = currentG - 5;
    s1 = (currentTime ~/ 10) + 1;
    s1 = s1 * 10;
    int s2;
    double per = (guessersId.length / a['counter']) * 100;
    s2 = per.round();
    s2 = 100 - s2;
    score = s1 + s2;
    score = score ~/ 2;
    //2 percentage of people who have already guessed

    //claculate score for denner
  }

  Widget guessWaitShow() {
    if (word != '*') {
      if (currentG > 1 && counter - 1 != guessersId.length) {
        if (!timerRunning) {
          madeIt = false;
            startTimer();                         //UNDO
          timerRunning = true;
        }
        return Guesser();
      } else {
        // if (counter - 1 != guesses)
        // {
        //    return WordWas();
        // }
        // else {

         subG.cancel();                        //UNDO
        currentG = 90;
        pointsG = [];
        timerRunning = false;
        return WordWas(); //change to word was
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
    currentG = 90;
    timerRunning = false;
    super.dispose();
  }
}

Future<void> sendMessage() async {
  await Firestore.instance
      .collection('rooms')
      .document(documentid)
      .updateData({'chat': chat, '$identity Chat': chat.length - 1});
}

Future<void> updateScore() async {
  int place = playersId.indexOf(identity);
  tempScore[place] = score;
  int previousScore = finalScore[place];
  int newScore = previousScore + score;
  finalScore[place] = newScore;
  guessersId = guessersId + [identity];
  int ind = playersId.indexOf(denId);
  int sum = 0;
  for (int k = 0; k < tempScore.length; k++) {
    if (k == ind) continue;
    sum = sum + tempScore[k];
  }
  sum = sum ~/ (counter - 1);
  tempScore[ind] = sum;
  finalScore[ind] = finalScore[ind] + sum;
  madeIt = true;
  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'tempScore': tempScore,
    'finalScore': finalScore,
    'guessersId': guessersId
  });
}

Widget chatList() {
  int lastIndex = a['$identity Chat'];
  if (lastIndex != null &&
      chat[lastIndex].substring(0, chat[lastIndex].indexOf('[')) != identity) {
    chat = chat + [newMessage];
    sendMessage();
  }
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
      return Column(
        crossAxisAlignment: (identity.toString() == i)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          (i == identity.toString())
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Bubble(
                          nip: BubbleNip.rightTop,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                            child: Column(
                              children: [
                                nameOfOthers(i, n),
                                Text('$m',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )),
                      CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.grey[100],
                        backgroundImage:
                            NetworkImage(playersImage[playersId.indexOf(i)]),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      (playersId.indexOf(i)==-1)?
                      Container():
                      CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.grey[100],
                        backgroundImage:
                            NetworkImage(
                              playersImage[playersId.indexOf(i)
                              ]
                              ),
                      ),
                      Bubble(
                        nip: BubbleNip.leftTop,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 2.0,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              nameOfOthers(i, n),
                              Text('$m',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Text('$nam',
          style: GoogleFonts.ubuntu(
              //   color: Color(0xFFA74AC7),
              color: Color(0xFFFF4893),
              fontSize: 10.0,
              fontWeight: FontWeight.bold)),
    );
}

class AnimatedAvatar extends StatefulWidget {
  @override
  _AnimatedAvatarState createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with TickerProviderStateMixin {
  
  @override
  initState() {
    controlAvatar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    double photoSize  =120.0;
    //double leftPadding= 70.0;
    double leftPadding = ((totalWidth/2)-50)- photoSize/2;
    //double topPadding = 20.0;
    double topPadding= ((guessCanvasLength/2)/2) - (photoSize/2 );
   
    double denIconSize= 50.0;
    double rightIconPadding = 5.0;
    double topIconPadding = 5.0;

     RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(
      leftPadding,
     topPadding,
     totalWidth-50-leftPadding-photoSize,
     (guessCanvasLength/2) -topPadding-photoSize  ),

    end: RelativeRect.fromLTRB( 
      totalWidth-50  - rightIconPadding- denIconSize ,
       topIconPadding, 
       rightIconPadding, 
         (guessCanvasLength/2) -topIconPadding-denIconSize
           ),
  );
    return Container(
      width: totalWidth-50,
      height: guessCanvasLength/2,
      child: Stack(
        children: <Widget>[
          PositionedTransition(
            rect: relativeRectTween.animate(controlAvatar),
            child: Container(
              child: ClipOval(
                child: Image.network(
                  playersImage[playersId.indexOf(denId)],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
