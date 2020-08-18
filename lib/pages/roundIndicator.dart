import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/pages/room/room.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';

import 'Select_room/createRoom.dart';

class RoundIndicator extends StatefulWidget {
  @override
  _RoundIndicatorState createState() => _RoundIndicatorState();
}

class _RoundIndicatorState extends State<RoundIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: totalWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int i = 1; i <= numberOfRounds; i++)
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: (i < round)
                        ? Colors.green
                        : (i == round) ? Colors.blue : Colors.white,
                    gradient: (i < round)
                        ? LinearGradient(
                            colors: [Colors.green[600], Colors.green[400]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                        : (i == round)
                            ? RadialGradient(
                                radius: 1.5,
                                colors: [Colors.blue[600], Colors.blue[600]])
                            : null
                    //  LinearGradient(
                    //     colors: [Colors.yellow[300], Colors.yellow[50]],
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter)
                    ),
                child: Text('$i',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: (i <= round) ? Colors.white : Colors.black)),
              ),
            )
        ],
      ),
    );
  }
}
