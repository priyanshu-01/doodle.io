import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints.expand(),
          color: Colors.orange[200],
          child: Text(
            'Loading...',
            style: GoogleFonts.quicksand(color: Colors.black, fontSize: 40.0),
          )),
    );
  }
}
