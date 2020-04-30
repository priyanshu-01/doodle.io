import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
class RoomCreatingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SpinKitChasingDots(
              color: Color(0xFF00008B),
              size: 150.0,
            ),
            Text('Just a Second...!',
            style: GoogleFonts.quicksand(
              color: Color(0xFF00008B),
              fontSize: 30.0

            ),
            )
          ],
        )
      ),
      
      
    );
  }
}