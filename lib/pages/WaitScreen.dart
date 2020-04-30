import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'room.dart';
import 'guesserScreen.dart';
class WaitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
            child: Container(
             // color: textAndChat,
             color: Colors.white,
             // height: 400.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex:5,
                                      child: SpinKitPouringHourglass(
                                        //color: Colors.white,
                                       // color: Color(0xFF9868AC),
                                       color: Color(0xFF1A2F77),
                 size: 100.0,),
                  ),
                  Flexible(
                    flex: 5,
                       child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('$denner is choosing a word',
                      textAlign: TextAlign.center,
                      style: 
                      GoogleFonts.
                      //quicksand(fontSize: 20.0,
                      notoSans(fontSize: 20.0,

                      //color: Colors.white
                      //color: Color(0xFF775169)
                      color: Color(0xFF392E40)
                      ),
                      ),
                    ),

                  ),
                  // Flexible( 
                  //   flex:1,
                  //    child:Divider(
                  //      color: Color(0xFF392E40),
                  //   endIndent: 60.0,
                  //   indent: 60.0,
                  //   thickness: 2.0,
                  //   ),)
                  
                  
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