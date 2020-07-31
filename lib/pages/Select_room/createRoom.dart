import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/room/room.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';

// int roundsLimit = 3;
int numberOfRounds = 3;

class MakeRoom extends StatefulWidget {
  final Currency currency;
  final String uid;
  MakeRoom({this.currency, this.uid});
  @override
  _MakeRoomState createState() => _MakeRoomState();
}

class _MakeRoomState extends State<MakeRoom> {
  bool processingCreateRoom = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: totalLength * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(15.0), child: DisplayRound()),
          InkWell(
            enableFeedback: false,
            onTap: () => (!processingCreateRoom) ? createRoom() : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: color['buttonBg'],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: (!processingCreateRoom)
                    ? Text(
                        'CREATE',
                        style: GoogleFonts.fredokaOne(
                            letterSpacing: 1.4,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1.0, -1.0),
                                  color: Colors.black),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.0, -1.0),
                                  color: Colors.black),
                              Shadow(
                                  // topRight
                                  offset: Offset(2.5, 2.5),
                                  color: Colors.black),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.0, 1.0),
                                  color: Colors.black),
                            ],
                            //color: Colors.orange[700],
                            color: color['bg2'],
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800),
                      )
                    : Container(
                        width: 150.0,
                        child: SpinKitFadingCircle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void createRoom() {
    audioPlayer.playSound('click');
    setState(() {
      processingCreateRoom = true;
    });
    flag = false;
    Random random = Random();
    double randomNumber;
    randomNumber = random.nextDouble();
    double d = randomNumber * 100000000;
    id = d.toInt();
    id = id * pow(10, 8 - id.toString().length);
    print(id);
    addRoom(widget.uid)
        .whenComplete(() => Timer(Duration(milliseconds: 150), () {
              Navigator.pop(context);
              Navigator.push(context, createRoute(id, widget.currency));
              processingCreateRoom = false;
            }));
  }
}

class DisplayRound extends StatefulWidget {
  @override
  _DisplayRoundState createState() => _DisplayRoundState();
}

class _DisplayRoundState extends State<DisplayRound> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Number of rounds',
          style: TextStyle(color: Colors.white),
        ),
        StepperSwipe(
          initialValue: numberOfRounds,
          onChanged: (int val) {
            numberOfRounds = val;
          },
          direction: Axis.horizontal,
          secondIncrementDuration: Duration(milliseconds: 500),
          withPlusMinus: true,
          dragButtonColor: Color(0xFFE9B123),
          iconsColor: Colors.blue[900],
          speedTransitionLimitCount: 3,
          withNaturalNumbers: true,
        ),
      ],
    );

    Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 45.0,
            ),
            onPressed: () {
              (numberOfRounds == 1)
                  ? null
                  : setState(() {
                      numberOfRounds = numberOfRounds - 1;
                    });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '$numberOfRounds',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              size: 45.0,
            ),
            onPressed: () {
              (numberOfRounds == 5)
                  ? null
                  : setState(() {
                      numberOfRounds = numberOfRounds + 1;
                    });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Rounds',
                style: TextStyle(
                  fontSize: 20.0,
                )),
          ),
        ],
      ),
    );
  }
}
