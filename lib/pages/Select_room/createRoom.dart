import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/room/room.dart';
import 'package:scribbl/virtualCurrency/data.dart';

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
          Padding(padding: const EdgeInsets.all(15.0), child: Container()),
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
    setState(() {
      processingCreateRoom = true;
    });
    flag = false;
    Random random = Random();
    double randomNumber;
    randomNumber = random.nextDouble();
    double d = randomNumber * 1000000;
    id = d.toInt();
    print(id);
    addRoom(widget.uid)
        .whenComplete(() => Timer(Duration(milliseconds: 150), () {
              Navigator.pop(context);
              Navigator.push(context, createRoute(id, widget.currency));
              processingCreateRoom = false;
            }));
  }
}
