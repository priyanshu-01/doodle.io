import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../room/room.dart';
import 'guesserScreen.dart';
import 'package:quiver/async.dart';
import '../Select_room/selectRoom.dart';
import '../../main.dart';
import '../Painter_screen/painterScreen.dart';

class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen>
    with SingleTickerProviderStateMixin {
  // String waitDenId;
  var waitSub;
  int waitCurrent;
  int end;
  double topPadding;

  AnimationController spinKitController;
  void initState() {
    avatarAnimation = animateAvatar.reset;
    // waitDenId = denId;
    topPadding = totalLength * 0.5;
    end = 15 + (counter * 2);
    waitCurrent = 0;
    spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = 0.0;
      });
    });
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    waitCurrent = 0;
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
      if (waitCurrent >= 13) {
        changeDenIfNeeded2();
      }
      waitCurrent = duration.elapsed.inSeconds;
    });
    waitSub.onDone(() {
      waitSub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (waitDenId != denId) {
    //   waitDenId = denId;
    //   waitCurrent = 0;
    //   waitSub.cancel();
    //   startTimer();
    // }
    return Stack(
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints.expand(),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticInOut,
          left: totalWidth * 0.27,
          top: topPadding,
          onEnd: () {
            // spinKitController.repeat();
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: totalLength * 0.25,
                ),
                SpinKitWave(
                  controller: spinKitController,
                  //color: Colors.white,
                  color: Color(0xFF9868AC),
                  // color: Color(0xFF1A2F77),
                  //size: 100.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '$denner',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.
                            //quicksand(fontSize: 20.0,
                            notoSans(fontSize: 20.0, color: Color(0xFF392E40)),
                      ),
                      Text(
                        'is choosing a word',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.
                            //quicksand(fontSize: 20.0,
                            notoSans(fontSize: 14.0, color: Color(0xFF392E40)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void changeDenIfNeeded2() {
    int distance;
    int d = playersId.indexOf(denId);
    int m = playersId.indexOf(identity);
    if (d <= m) {
      distance = m - d;
    } else {
      distance = counter + m - d;
    }
    if (waitCurrent == 13 + (distance * 2) && resumed && online) {
      changeDen(
          'WaitScreen.dart line 131 and value of waitCurrent is $waitCurrent');
    }
  }
}
