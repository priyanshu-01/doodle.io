import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/audioPlayer/audioPlayer.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/editProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/loading.dart';
import 'package:scribbl/services/authHandler.dart';

class DesignLoginOptions extends StatefulWidget {
  @override
  _DesignLoginOptionsState createState() => _DesignLoginOptionsState();
}

class _DesignLoginOptionsState extends State<DesignLoginOptions> {
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioPlayer.initialiseSounds().whenComplete(() {
      FirebaseFirestore.instance
          .collection('avatars')
          .doc('images')
          .get()
          .then((value) {
        setState(() {
          avatarDocument = value;
          imageUrl = avatarDocument.data()['images'][0];
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalLength = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;

    return (avatarDocument == null)
        ? Loading()
        : Scaffold(
            body: Stack(
              children: [
                Opacity(
                  opacity: 0.85,
                  child: Container(
                    color: Colors.black,
                    constraints: BoxConstraints.expand(),
                  ),
                ),
                Center(child: EditProfile()),
              ],
            ),
          );
  }
}
