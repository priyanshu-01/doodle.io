import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'room/room.dart';
import 'dart:math';
import 'Painter_screen/painterScreen.dart';
import 'selectRoom.dart';
import 'dart:async';

class ChooseWordDialog extends StatefulWidget {
  @override
  _ChooseWordDialogState createState() => _ChooseWordDialogState();
}

class _ChooseWordDialogState extends State<ChooseWordDialog> {
List displayWords = [' ', ' ', ' '];

Color wordBack;
Color wordText;

bool switcher=false;

double topPadding= totalLength*0.8;
Curve curve= Curves.elasticOut; 
Duration duration = Duration(milliseconds: 1000);
@override
  void initState() {
        getWords();
         WidgetsBinding.instance.addPostFrameCallback((_) {
           setState(() {
             topPadding=totalLength*0.1;
           });
                });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //wordBack= Color(0xFFFFE5B4);
    wordBack = null;
    // wordText=Color(0xFF1A2F77);
    wordText = Colors.black;
    return Stack(
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints.expand(),
        ),
        AnimatedPositioned(
          duration: duration,
          top:topPadding,
          left: totalWidth*0.15,
          curve: curve,
          onEnd: (){
            if(topPadding!=totalLength*0.1)
            updateWord();
            },
                  child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Pick a word',
                style: GoogleFonts.notoSans(color: Colors.black, fontSize: 25.0),
              ),
              SizedBox(height: totalLength*0.05,),
              Container(
                  height: 200.0,
                  //color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        color: wordBack,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: Text(
                          displayWords[0].toUpperCase(),
                          style:
                              GoogleFonts.poppins(color: wordText, fontSize: 18.0),
                        ),
                        onPressed: () {
                          choosenWord = displayWords[0];
                          //updateWord();
                          setState(() {
                            topPadding=totalLength*0.8;
                            curve = Curves.easeInBack;
                            duration= Duration(milliseconds: 500);
                          });
                        },
                      ),
                      FlatButton(
                        color: wordBack,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: Text(
                          displayWords[1].toUpperCase(),
                          style:
                              GoogleFonts.poppins(color: wordText, fontSize: 18.0),
                        ),
                        onPressed: () {
                          choosenWord = displayWords[1];
                          //updateWord();
                           setState(() {
                            topPadding=totalLength*0.8;
                            curve = Curves.easeInBack;
                            duration= Duration(milliseconds: 500);

                          });
                        },
                      ),
                      FlatButton(
                        color: wordBack,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: Text(
                          displayWords[2].toUpperCase(),
                          style:
                              GoogleFonts.poppins(color: wordText, fontSize: 18.0),
                        ),
                        onPressed: () {
                          choosenWord = displayWords[2];
                          //updateWord();
                           setState(() {
                            topPadding=totalLength*0.8;
                            curve = Curves.easeInBack;
                            duration= Duration(milliseconds: 500);

                          });
                        },
                      ),
                      SizedBox(height: totalLength*0.03,),
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

  void getWords() async {
    int length;
    List word = wordListDocument['list'];
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
  await Firestore.instance
      .collection('rooms')
      .document(documentid)
      .updateData({'word': choosenWord, 'wordChosen': true});
}


class TimeIndicator extends StatefulWidget {
  @override
  TimeIndicatorState createState() => TimeIndicatorState();
}

class TimeIndicatorState extends State<TimeIndicator> with TickerProviderStateMixin {
  Color green = Color(0xFF008000);
  Color red= Color(0xFFFF0000);
  double width = totalWidth * 0.75;
  AnimationController timeIndicator;
  Animation _colorTween;
  @override
  void initState() {
    timeIndicator = AnimationController(
    vsync: this,
    duration: Duration(seconds: 15),
    lowerBound: 0.0,
    upperBound: 1.0
    );
    super.initState();
    _colorTween = ColorTween(begin: green, end: red)
        .animate(timeIndicator);
        Timer(
        Duration(
          milliseconds: 800,
        ), () {
        timeIndicator.forward(from:0.0);
        });
  }
  @override
  void dispose() {
    timeIndicator.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return   RepaintBoundary(
          child: Container(
                      width:width,
                      alignment: Alignment.centerLeft,
                      child: AnimatedBuilder(
                        animation: timeIndicator,
                         builder:(context,child){
                          return Container(                    
                          height: 12.0,
                         // width: animatedWidth,
                         width: (1-timeIndicator.value) *width,
                          decoration: BoxDecoration(
                              color: _colorTween.value,
                              border: Border.all(color: _colorTween.value),
                              borderRadius: BorderRadius.circular(15.0)),
                        );}
                      ),
                    ),
    );
  }
}
