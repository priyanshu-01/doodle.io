import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Select_room/selectRoom.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    totalLength = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;

    return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        // color: Colors.orange[200],
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.blue[400], Colors.blue[900]],
                focalRadius: 0.2,
                radius: 0.8)),
        child: Column(
          children: [
            SizedBox(
              height: totalLength * 0.1,
            ),
            Text(
              'Doodle',
              style: getTitleTextStyle(50.0),
            ),
            Text(
              'Friends',
              style: getTitleTextStyle(50.0),
            ),
            SizedBox(
              height: totalLength * 0.4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Loading', style: getTitleTextStyle(25.0)),
                SizedBox(
                  width: 20.0,
                ),
                SpinKitCircle(
                  color: Colors.white,
                  size: 40.0,
                )
              ],
            ),
          ],
        ));
  }

  TextStyle getTitleTextStyle(double fontSize) {
    return GoogleFonts.fredokaOne(
      color: Colors.white,
      fontSize: fontSize,
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
            offset: Offset(1.5, 1.8),
            color: Colors.black),
        Shadow(
            // topLeft
            offset: Offset(-1.0, 1.0),
            color: Colors.black),
      ],
    );
  }
}
