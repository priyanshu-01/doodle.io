import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'room.dart';
class WaitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
            child: Container(
              color: Colors.orange[800],
             // height: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex:5,
                                      child: SpinKitPouringHourglass(color: Colors.white,
                 size: 150.0,),
                  ),
                  Flexible(
                    flex: 5,
                       child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('$denner is choosing a word',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(fontSize: 30.0,
                      color: Colors.white
                      ),
                      ),
                    ),

                  ),
                  Flexible( 
                    flex:1,
                     child:Divider(color: Colors.white,
                    endIndent: 40.0,
                    indent: 40.0,
                    thickness: 2.0,
                    ),)
                  
                  
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
          );
    
  }
}