import 'dart:async';
import 'dart:ui';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../room/room.dart';
import '../selectRoom.dart';
import 'package:flutter/rendering.dart';
import '../../gift/gift_contents.dart';
import 'Widgets/chat.dart';
import 'Widgets/gameContent.dart';
import 'Widgets/stackContent.dart';
import 'Widgets/textBox.dart';
bool timerRunning = false;
final messageHolder = TextEditingController();
String message = '';
double guessCanvasLength;
bool keyboardState=false;
String newMessage;
Color textAndChat = Color(0xFFFFF1E9);
int score = 0;
String tempDenId;
AnimationController controlGift;
enum animateAvatar { start, done, reset }
var avatarAnimation;

class GuesserScreen extends StatefulWidget {
  @override
  _GuesserScreenState createState() => _GuesserScreenState();
}

class _GuesserScreenState extends State<GuesserScreen> {
  //Color textAndChat= Color(0xFFECC5C0);

  StreamSubscription subscription;
  @override
  void initState() {
    guessCanvasLength = (((effectiveLength * 0.6) - 50) * (7 / 8));
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(children: <Widget>[
            Container(
                color: Colors.white,
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: <Widget>[
                    Flexible(
                        flex: 6,
                        child: GestureDetector(
                            onTap: () {
                              if (controlGift.value == 1.0) {
                                controlGift.reverse(from: 1.0);
                              }
                            },
                            child: GuessWaitShow())),
                    TextBox(),
                    Flexible(
                      flex: (keyboardState) ? 0 : 4,
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            ChatBox(),
                            AnimatedGift()
                            //)
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            StackContent(position: 'guesser',)
          ]),
        ),
      ),
    );
  }



  @override
  void dispose() {
    keyboardState=false;
    subscription.cancel();
    super.dispose();
  }
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
  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'tempScore': tempScore,
    'finalScore': finalScore,
    'guessersId': guessersId
  });
}




