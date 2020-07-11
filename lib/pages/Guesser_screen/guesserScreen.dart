import 'dart:async';
import 'dart:ui';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/pages/enterName.dart';
import '../roundIndicator.dart';
import 'guesser.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../room/room.dart';
import '../Select_room/selectRoom.dart';
import 'package:google_fonts/google_fonts.dart';
import '../wordWas.dart';
import 'WaitScreen.dart';
import 'package:quiver/async.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/rendering.dart';
import '../../gift/gift_contents.dart';
import 'animatedAvatar.dart';
import 'chat.dart';

bool timerRunning = false;
final messageHolder = TextEditingController();
String message = '';
double guessCanvasLength;
bool keyboardState = false;
String newMessage;
Color textAndChat = Colors.grey[200];
//Color(0xFFFFF1E9);
int score = 0;
String tempDenId;
AnimationController controlGift;
enum animateAvatar { start, done, reset }
var avatarAnimation;
bool keyboardSet = false;
List popUpStack = [];
int popUpAdder = 0;
int popUpRemover = 0;
// int currentG = 92;

class GuesserScreen extends StatelessWidget {
  //Color textAndChat= Color(0xFFECC5C0);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          color: Colors.white,
          constraints: BoxConstraints.expand(),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        if (controlGift.value == 1.0) {
                          controlGift.reverse(from: 1.0);
                        }
                      },
                      child: GuessWaitShow())),
              TextBox(),
              RoundIndicator(),
              KeyboardListener()
            ],
          )),
      Positioned(
          left: 50.0, bottom: keyboardHeight + 110.0, child: PopUpChat()),
      StackChild(position: 'guesser')
    ]);
  }
}

class PopUpChat extends StatefulWidget {
  @override
  _PopUpChatState createState() => _PopUpChatState();
}

class _PopUpChatState extends State<PopUpChat> {
  @override
  Widget build(BuildContext context) {
    print('popUpAdder= $popUpAdder');
    print('popUpRemover= $popUpRemover');
    if (chat.length > popUpAdder) {
      int future = chat.length - popUpAdder;
      popUpAdder = chat.length;
      Timer(
          Duration(
            seconds: 3,
          ), () {
        setState(() {
          popUpRemover = popUpRemover +
              future; //the value of future might change in less than 2 seconds
        });
      });
    }
    popUpStack = (popUpRemover < chat.length) ? chat.sublist(popUpRemover) : [];
    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      // color: Colors.green,
      height: totalLength * 0.3,
      width: totalWidth * 0.45,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          reverse: true,
          itemCount: popUpStack.length,
          itemBuilder: (BuildContext context, int index) {
            String both = popUpStack[popUpStack.length - 1 - index];
            String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
            String m = both.substring(both.indexOf(']') + 1);
            return Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                child: RichText(
                    textAlign: TextAlign.left,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textScaleFactor: 0.9,
                    text: (m != 'd123')
                        ? new TextSpan(
                            text: '$n ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: <TextSpan>[
                              new TextSpan(
                                text: m,
                                style: DefaultTextStyle.of(context).style,
                              ),
                            ],
                          )
                        : TextSpan(
                            text: '$n guessed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
              ),
            );
          }),
    );
  }
}

class KeyboardListener extends StatefulWidget {
  @override
  _KeyboardListenerState createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<KeyboardListener> {
  StreamSubscription subscription;

  @override
  void initState() {
    guessCanvasLength = ((totalLength - 50 - 20 - keyboardHeight) *
        (7 / 8)); //50 is textField and 20 is roundIndicator
    super.initState();
    keyboardState = KeyboardVisibility.isVisible;
    subscription = KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        keyboardState = visible;
        if (keyboardState && controlGift.value == 1.0) {
          controlGift.value = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!keyboardSet && keyboardState) {
      keyboardSet = true;
      setState(() {
        print('keyboard set');
        keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        guessCanvasLength =
            (((totalLength) - 50 - 20 - keyboardHeight) * (7 / 8));
      });
    }
    return Container(
      height: keyboardHeight,
      child: Stack(
        children: <Widget>[ChatBox(), AnimatedGift()],
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class StackChild extends StatelessWidget {
  final String position;
  StackChild({this.position});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: position == 'guesser' ? guessCanvasLength : denCanvasLength,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              alignment: AlignmentDirectional.topCenter,
              height: position == 'guesser'
                  ? guessCanvasLength - 15
                  : denCanvasLength - 15,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  for (var playerIdentity in playersId)
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: (guessersId.indexOf(playerIdentity) == -1)
                            ? (denId == playerIdentity)
                                ? CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.blue,
                                    child: CircleAvatar(
                                      radius: 17.5,
                                      backgroundImage: NetworkImage(
                                          playersImage[
                                              playersId.indexOf(playerIdentity)
                                              // index
                                              ]),
                                      backgroundColor: Colors.grey[100],
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: NetworkImage(playersImage[
                                        // playersId.indexOf(guessersId[index])
                                        playersId.indexOf(playerIdentity)]),
                                  )
                            : CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.green[400],
                                child: CircleAvatar(
                                  radius: 17.5,
                                  backgroundImage: NetworkImage(playersImage[
                                      // playersId.indexOf(guessersId[index])
                                      playersId.indexOf(playerIdentity)]),
                                  backgroundColor: Colors.grey[100],
                                ),
                              )),
                ],
              )),
          position == 'guesser' ? AnimatedAvatar() : Container()
        ],
      ),
    );
  }
}

double checkLeftSideContainerHeight(String position) {
  double tempHeight;
  int len;
  (position == 'guesser')
      ? tempHeight = guessCanvasLength - 15
      : tempHeight = denCanvasLength - 15;
  int i = (tempHeight ~/ 50);
  if (i < playersId.length)
    len = i * 50;
  else
    len = playersId.length * 50;
  return len.toDouble();
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
  //madeIt = true;
  // score = 0;

  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'tempScore': tempScore,
    'finalScore': finalScore,
    'guessersId': guessersId
  });
}

class GuessWaitShow extends StatefulWidget {
  @override
  _GuessWaitShowState createState() => _GuessWaitShowState();
}

class _GuessWaitShowState extends State<GuessWaitShow> {
  int startG = guesserCountDown.initialValue;
  var subG;
  @override
  Widget build(BuildContext context) {
    if (word != '*') {
      if (guesserCountDown.current > 3 && counter - 1 != guessersId.length) {
        if (!timerRunning || tempDenId != denId) {
          tempDenId = denId;
          startTimer();
          timerRunning = true;
        }
        return Guesser();
      } else {
        timerZero2();
        return WordWas();
      }
    } else {
      if (guesserCountDown.current != guesserCountDown.initialValue) {
        print('timerStoppedForcefully ');
        timerZero();
      }
      return WaitScreen();
    }
  }

  void timerZero() {
    print('timerZero called');
    subG.cancel();
    guesserCountDown.current = guesserCountDown.initialValue;
    pointsG = [];
    timerRunning = false;
  }

  void timerZero2() {
    if (subG != null) subG.cancel();
    pointsG = [];
    timerRunning = false;
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: startG),
      new Duration(seconds: 1),
    );

    subG = countDownTimer.listen(null);
    subG.onData((duration) {
      if (guesserCountDown.current <= 3)
        setState(() {
          guesserCountDown.setCurrent = startG - duration.elapsed.inSeconds;
        });
      else
        guesserCountDown.setCurrent = startG - duration.elapsed.inSeconds;
    });

    subG.onDone(() {
      print('subG.onDone() called');
      timerRunning = false;
      //word = '*';
      pointsG = [];
      subG.cancel();
      guesserCountDown.current = guesserCountDown.initialValue;
    });
  }

  @override
  void dispose() {
    word = '*';
    if (subG != null) subG.cancel();
    guesserCountDown.current = guesserCountDown.initialValue;
    timerRunning = false;
    super.dispose();
  }
}

class TextBox extends StatefulWidget {
  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final FocusNode fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
              child: InkWell(
                enableFeedback: false,
                child: const Image(
                  image: AssetImage('assets/icons/gift.gif'),
                ),
                onTap: () {
                  if (fn.hasFocus) {
                    fn.unfocus();
                    controlGift.forward(from: 0.0);
                  } else {
                    (controlGift.value == 0.0)
                        ? controlGift.forward(from: 0.0)
                        : controlGift.reverse();
                  }
                },
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
              onSubmitted: (String a) => onSend(),
            ),
          ),
          // (message == '')
          //     ? (keyboardState)
          //         ? IconButton(
          //             icon: Icon(
          //               Icons.keyboard_arrow_down,
          //               size: 30.0,
          //               color: Color(0xFFFF4893),
          //             ),
          //             onPressed: () {
          //               fn.unfocus();
          //               // FocusScope.of(context).unfocus();
          //             },
          //           )
          //         : IconButton(
          //             icon: Icon(
          //               Icons.keyboard_arrow_up,
          //               size: 30.0,
          //               color: Color(0xFFFF4893),
          //             ),
          //             onPressed: () {
          //               fn.requestFocus();
          //             },
          //           )
          //     :
          IconButton(
            icon: Icon(
              Icons.send,
              //color: Color(0xFF16162E),
              color: Color(0xFFFF4893),
              //  color: Color(0xFF1A2F77),
              //   color: Color(0xFFA74AC7),
              size: 30.0,
            ),
            //onPressed:=>onSend(),
            onPressed: () => onSend(),
          ),
        ],
      ),
    );
  }

  void onSend() {
    message = ' $message ';
    if (message != '  ') {
      messageHolder.clear();
      // messageHolder.clearComposing();
      String lowerCase = message.toLowerCase();
      if (lowerCase.indexOf(word) != -1) {
        message = 'd123';
        if (guessersId.indexOf(identity) == -1) {
          if (guessersId.length < counter - 2) showPopup(context);
          calculateScore();
          updateGuesserId();
          newMessage = '$identity[$userNam]$message';
          chat.add(newMessage);
          sendMessage();
        }
      } else {
        newMessage = '$identity[$userNam]$message';
        chat.add(newMessage);
        sendMessage();
      }
    }
    message = '';
    // fn.unfocus();
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
    int currentTime = guesserCountDown.current - 2;
    s1 = (currentTime ~/ 10) + 1;
    s1 = s1 * 10;
    int s2;
    double per = (guessersId.length / roomData['counter']) * 100;
    s2 = per.round();
    s2 = 100 - s2;
    score = s1 + s2;
    score = score ~/ 2;
    //2 percentage of people who have already guessed

    //claculate score for denner
  }
}
