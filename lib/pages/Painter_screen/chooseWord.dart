import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/services/authHandler.dart';
import '../room/room.dart';
import 'dart:math';
import 'painterScreen.dart';
import '../Select_room/selectRoom.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

String onWordChoosen =
    "https://us-central1-doodle-290309.cloudfunctions.net/onWordChoosen";

Color chooseWordBackColor = Colors.blue[700];
Color chooseWordTextColor = Colors.white;
TextStyle chooseWordStyle = GoogleFonts.ubuntu(
    color: chooseWordTextColor,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8);

class ChooseWordDialog extends StatefulWidget {
  @override
  _ChooseWordDialogState createState() => _ChooseWordDialogState();
}

class _ChooseWordDialogState extends State<ChooseWordDialog> {
  List displayWords = [' ', ' ', ' '];

  bool switcher = false;

  double topPadding = totalLength * 0.8;
  Curve curve = Curves.easeOutBack;
  Duration duration = Duration(milliseconds: 1000);
  @override
  void initState() {
    getWords();
    audioPlayer.playSound('pickAWord');
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
                Container(
                  // decoration: overlayBoxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pick a word',
                      style:
                          //  overlayTextStyle
                          GoogleFonts.fredokaOne(
                        // color: Colors.brown,
                        color: Color(0xFF1f1f1f),
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: totalLength * 0.045,
                ),
                Container(
                    height: 200.0,
                    //color: Colors.red,
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                            color: chooseWordBackColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(7.0)),
                            child: Text(
                              displayWords[0]
                              // .toUpperCase()
                              ,
                              style: chooseWordStyle,
                            ),
                            onPressed: () => onWordPressed(displayWords[0])),
                        FlatButton(
                            color: chooseWordBackColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(7.0)),
                            child: Text(
                                displayWords[1]
                                // .toUpperCase()
                                ,
                                style: chooseWordStyle),
                            onPressed: () => onWordPressed(displayWords[1])),
                        FlatButton(
                          color: chooseWordBackColor,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(7.0)),
                          child: Text(
                              displayWords[2]
                              // .toUpperCase()
                              ,
                              style: chooseWordStyle),
                          onPressed: () => onWordPressed(displayWords[2]),
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
    audioPlayer.playSound('click');
    setState(() {
      choosenWord = choosen;
      topPadding = totalLength * 0.8;
      curve = Curves.easeInBack;
      duration = Duration(milliseconds: 500);
      wordCheck.addWord(choosen);
      allAttemptedWords = allAttemptedWords + [choosen];
    });
  }

  void getWords() async {
    int length;
    wordList.removeWhere((e) => allAttemptedWords.contains(e));
    length = wordList.length;
    Random random = Random();
    double randomNumber;
    int index;
    for (int i = 0; i < 3; i++) {
      randomNumber = random.nextDouble() * (length - 1);
      index = randomNumber.toInt();
      displayWords[i] = (wordList[index]);
      if (i == 1) {
        if (displayWords[0] == displayWords[1]) i--;
      } else if (i == 2) {
        if (displayWords[0] == displayWords[2] ||
            displayWords[1] == displayWords[2]) i--;
      }
    }
  }
}

Future<void> updateWord() async {
  roomData['word'] = word;
  FirebaseFirestore.instance.collection('rooms').doc(documentid).update({
    'word': choosenWord,
    'wordChosen': true,
    'allAttemptedWords': allAttemptedWords,
  });

  await http.post(Uri.encodeFull(onWordChoosen),
      headers: {'roomdata': json.encode(roomData)}).then((data) {
    if (data.statusCode == 200) {
      print(json.decode(data.body));
    } else {
      print(data.statusCode);
    }
  }).catchError((_) {
    print('caught error');
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
