import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'room.dart';
import 'guesserScreen.dart';
import 'package:quiver/async.dart';
import 'selectRoom.dart';
import '../main.dart';
import 'painterScreen.dart';
  var waitSub;
 int waitCurrent = 0;
class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}
class _WaitScreenState extends State<WaitScreen> {
String waitDenId;
  int end = 30+(counter*2);
    void initState() {
    waitDenId=denId;
    waitCurrent=0;
    startTimer();
    super.initState();
  }
  @override
  void dispose() {
      waitCurrent=0;
    waitSub.cancel();
    super.dispose();
  }
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: end),
      new Duration(seconds: 1),
    );
    waitSub = countDownTimer.listen(null);
    waitSub.onData((duration) {
      if (waitCurrent >= 28) {
      changeDenIfNeeded2();
      }
      waitCurrent = duration.elapsed.inSeconds;
    });
    waitSub.onDone(() {
      waitSub.cancel();
      //  changeDen();
    });
  }
  @override
  Widget build(BuildContext context) {
    if(waitDenId!=denId){
      waitDenId=denId;
          waitCurrent = 0;
          waitSub.cancel();
          startTimer();
    }
    return Center(
      child: Container(
        // color: textAndChat,
        color: Colors.white,
        // height: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: SpinKitPouringHourglass(
                //color: Colors.white,
                // color: Color(0xFF9868AC),
                color: Color(0xFF1A2F77),
                size: 100.0,
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '$denner is choosing a word',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.
                      //quicksand(fontSize: 20.0,
                      notoSans(
                          fontSize: 20.0,

                          //color: Colors.white
                          //color: Color(0xFF775169)
                          color: Color(0xFF392E40)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void changeDenIfNeeded2(){
    int distance;
     int d= playersId.indexOf(denId);
     int m= playersId.indexOf(identity);
     if(d<=m){
     distance= m-d;
     }
     else{
       distance= counter+ m-d;
     }
     if(waitCurrent==28+(distance*2)   && resumed && online)
     changeDen();
  }
}

