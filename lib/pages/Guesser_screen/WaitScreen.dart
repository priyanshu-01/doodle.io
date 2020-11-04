import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../room/room.dart';
import 'guesserScreen.dart';
import '../Select_room/selectRoom.dart';

class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen>
    with SingleTickerProviderStateMixin {
  int end;
  double topPadding;

  AnimationController spinKitController;
  void initState() {
    avatarAnimation = animateAvatar.reset;
    topPadding = totalLength * 0.5;
    spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        topPadding = 0.0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
}
