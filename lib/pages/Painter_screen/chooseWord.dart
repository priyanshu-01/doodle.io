import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/services/authHandler.dart';
import '../room/room.dart';
import 'dart:math';
import 'painterScreen.dart';
import '../Select_room/selectRoom.dart';
import 'dart:async';

class ChooseWordDialog extends StatefulWidget {
  @override
  _ChooseWordDialogState createState() => _ChooseWordDialogState();
}

class _ChooseWordDialogState extends State<ChooseWordDialog> {
  List displayWords = [' ', ' ', ' '];

  Color wordBack = Colors.black;
  Color wordText = Colors.white;
  TextStyle wordStyle;

  bool switcher = false;

  double topPadding = totalLength * 0.8;
  Curve curve = Curves.easeOutBack;
  Duration duration = Duration(milliseconds: 1000);
  @override
  void initState() {
    wordStyle = GoogleFonts.poppins(
        color: wordText,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5);
    getWords();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = totalLength * 0.1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // wordBack = Color(0xFF504A4B);
    // wordBack = Colors.black;

    // wordText=Color(0xFF1A2F77);
    return Stack(
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints.expand(),
        ),
        AnimatedPositioned(
          duration: duration,
          top: topPadding,
          left: totalWidth * 0.15,
          curve: curve,
          onEnd: () {
            if (topPadding != totalLength * 0.1) updateWord();
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Pick a word',
                  style:
                      GoogleFonts.notoSans(color: Colors.black, fontSize: 25.0),
                ),
                SizedBox(
                  height: totalLength * 0.07,
                ),
                Container(
                    height: 200.0,
                    //color: Colors.red,
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          color: wordBack,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          child: Text(
                            displayWords[0].toUpperCase(),
                            style: wordStyle,
                          ),
                          onPressed: () {
                            setState(() {
                              onWordPressed(displayWords[0]);
                            });
                          },
                        ),
                        FlatButton(
                          color: wordBack,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          child: Text(displayWords[1].toUpperCase(),
                              style: wordStyle),
                          onPressed: () {
                            setState(() {
                              onWordPressed(displayWords[1]);
                            });
                          },
                        ),
                        FlatButton(
                          color: wordBack,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          child: Text(displayWords[2].toUpperCase(),
                              style: wordStyle),
                          onPressed: () {
                            setState(() {
                              onWordPressed(displayWords[2]);
                            });
                          },
                        ),
                        SizedBox(
                          height: totalLength * 0.03,
                        ),
                        TimeIndicator()
                      ],
                    ))
              ],
            ),
          ),
        ),
      ],
    );

    //
  }

  void onWordPressed(String choosen) {
    choosenWord = choosen;
    topPadding = totalLength * 0.8;
    curve = Curves.easeInBack;
    duration = Duration(milliseconds: 500);
    wordCheck.addWord(choosen);
    allAttemptedWords = allAttemptedWords + [choosen];
  }

  void getWords() async {
    int length;
    wordList.removeWhere((e) => allAttemptedWords.contains(e));
    List word = wordList;
    length = word.length;
    Random random = Random();
    double randomNumber;
    int index;
    for (int i = 0; i < 3; i++) {
      randomNumber = random.nextDouble() * (length - 1);
      index = randomNumber.toInt();
      displayWords[i] = (word[index]);
    }
  }
}

Future<void> updateWord() async {
  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'word': choosenWord,
    'wordChosen': true,
    'allAttemptedWords': allAttemptedWords,
  });
}

class TimeIndicator extends StatefulWidget {
  @override
  TimeIndicatorState createState() => TimeIndicatorState();
}

class TimeIndicatorState extends State<TimeIndicator> {
  static Color green = Color(0xFF008000);
  static Color red = Color(0xFFFF0000);
  double width = totalWidth * 0.75;
  double animatedWidth = totalWidth * 0.75;
  Color color = green;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      setState(() {
        color = red;
        animatedWidth = 0.0;
      });

      // print("Yeah, this line is printed after 3 seconds");
    });

    //  WidgetsBinding.instance.addPostFrameCallback((_) { });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: width,
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: Duration(seconds: 14),
          height: 12.0,
          width: animatedWidth,
          decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }
}
