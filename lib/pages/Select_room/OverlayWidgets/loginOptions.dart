import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/editProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/services/authHandler.dart';

class LoginOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: totalLength * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Login'),
          InkWell(
            onTap: () {
              audioPlayer.playSound('çlick');
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sign in with G'),
              ),
            ),
          ),
          Text('OR'),
          InkWell(
            enableFeedback: false,
            onTap: () {
              audioPlayer.playSound('çlick');
              // overlayBuilder.hide();
              overlayBuilder.show(context, EditProfile());
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Play as Guest'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
