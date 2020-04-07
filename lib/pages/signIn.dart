import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            
            Image(image:AssetImage('assets/images/google.png') ,height: 150.0,),
            Text('Signing in...',
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 30.0

            ),
            )
          ],
        )
      ),
      
      
    );
  }
}