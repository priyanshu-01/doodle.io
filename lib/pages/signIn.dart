import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Select_room/selectRoom.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    totalLength = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;

    return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        color: Colors.orange[200],
        child: Text(
          'Loading...',
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 40.0),
        ));
  }
}
