import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/OverlayManager/necessaryOverlayBuilder.dart';
import 'package:scribbl/gift/gift_contents.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/services/authService.dart';

class LoginOptions extends StatefulWidget {
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: totalLength * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
              child: Text(
                'Login',
                style: myTextStyle(size: 18),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                enableFeedback: false,
                onTap: () {
                  audioPlayer.playSound('click');

                  GoogleAuthentication().signInWithGoogle();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.yellow[800])),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign in with ',
                          style: myTextStyle(size: 16.0),
                        ),
                        Image(
                          image: AssetImage('assets/images/google.png'),
                          height: 30.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+ 500',
                    style: myTextStyle(size: 12.0),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Container(height: 18.0, child: coinImage)
                ],
              )
            ],
          ),
          Text('OR', style: myTextStyle()
              //  GoogleFonts.fredokaOne(color: Colors.white),
              ),
          InkWell(
            enableFeedback: false,
            onTap: () {
              audioPlayer.playSound('click');

              menu = dialogMenu.editProfile;
              dialogMenuKey.currentState.setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Play as Guest', style: myTextStyle()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle myTextStyle({double size}) {
  if (size == null) size = 15.0;
  TextStyle myTextStyle = GoogleFonts.fredokaOne(
      color: Colors.white, fontSize: size, letterSpacing: 0.7);
  return myTextStyle;
}
