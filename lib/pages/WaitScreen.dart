import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class WaitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Container(
              color: Colors.orange[800],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SpinKitPouringHourglass(color: Colors.white,
                 size: 150.0,),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: <Widget>[
                        Text('denner is choosing a word',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(fontSize: 30.0,
                        color: Colors.white
                        ),
                        ),
                        SizedBox(height: 20.0,),
                        Divider(color: Colors.white,
                  endIndent: 40.0,
                  indent: 40.0,
                  thickness: 2.0,
                  ),
                      ],
                    ),
                  ),
                  
                  
                  // SpinKitPulse(
                  //   color: Colors.green,
                  // ),
                  // SpinKitChasingDots(
                  //   color: Colors.blue,
                  // ),
                  // SpinKitThreeBounce(
                  //   color: Colors.blue,
                  // ),
                  // SpinKitRipple(
                  //   color: Colors.blue,
                  // )

                ],
              ),
        
      ),
          ),
    );
  }
}