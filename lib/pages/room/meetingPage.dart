import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Select_room/selectRoom.dart';
import 'room.dart';

class WaitingForFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Text(
          //   'Waiting for friends to join...',
          //   style: TextStyle(color: Colors.white,
          // ),
          SpinKitThreeBounce(
            color: Colors.yellow[700],
            size: 40.0,
            duration: Duration(milliseconds: 800),
          ),
        ],
      ),
    );
  }
}

class StartStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (identity == hostId)
      return InkWell(
        onTap: (counter > 1)
            ? () {
                audioPlayer.playSound('click');
                game = true;
                startGame();
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: (counter > 1) ? Colors.green[700] : Colors.grey[700],
            ),
            borderRadius: BorderRadius.circular(18.0),
            color: (counter > 1) ? Colors.green[700] : Colors.grey[700],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 22.0),
            child: Text('START',
                style: GoogleFonts.fredokaOne(
                    color: Colors.white,
                    letterSpacing: 1.3,
                    // Color(0xFFFFF1E9)
                    fontWeight: FontWeight.w500,
                    fontSize: 23.0)),
          ),
        ),
        // Color(0xFFFF4893),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(top: 14.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AutoSizeText('$host will start the Game',
                  maxFontSize: 25.0,
                  minFontSize: 10.0,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                      color: Colors.white, fontSize: 20.0)),
            ),
          ],
        ),
      );
  }

  Future<void> startGame() async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(documentid)
        .update({
      'game': game,
    });
  }
}

class JoiningList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: RepaintBoundary(
        child: Container(
          width: totalWidth * 0.7,
          child: Card(
            elevation: 15.0,
            shadowColor: Colors.blue[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: counter,
                  itemBuilder: (BuildContext context, int a) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 4.0, left: 4.0, right: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.yellow[700],
                            // Color(0xFFFFD5D5)
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellow[700],
                          // gradient: LinearGradient(colors: [
                          //   Colors.blue[700],
                          //   Colors.blue[300]
                          // ]
                          // )
                          //  Color(0xFFFFD5D5),
                        ),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 9.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 21.5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage:
                                        NetworkImage(playersImage[a]),
                                    radius: 20.0,
                                  ),
                                )),
                            Text(
                              players[a],
                              style: GoogleFonts.fredokaOne(
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w400,
                                fontSize: 20.0,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      // bottomLeft
                                      offset: Offset(-1.0, -1.0),
                                      color: Colors.black),
                                  Shadow(
                                      // bottomRight
                                      offset: Offset(1.0, -1.0),
                                      color: Colors.black),
                                  Shadow(
                                      // topRight
                                      offset: Offset(2.0, 2.0),
                                      color: Colors.black),
                                  Shadow(
                                      // topLeft
                                      offset: Offset(-1.0, 1.0),
                                      color: Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class RoomIdentity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Text(
              'Room id : $roomID',
              style: GoogleFonts.quicksand(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Share this with your friends',
                      style: GoogleFonts.quicksand(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(' and ask them to join!',
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    // color: Color(0xFFFF4893),
                    color: Color(0xFFF6EC13),
                    size: 30.0,
                  ),
                  onPressed: () {
                    Share.share(
                        'Hey! I want to play Doodle Friends with you, Join me using this Room id :                                       "$roomID"');
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          //color: Color(0xFFFFD5D5),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue[900]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: Color(0xFFE9B123), width: 2.0),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0))),
    );
  }
}

class MeetingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 0.8,
              colors: [
                Colors.white,
                Colors.blue[300],
                Color(0xFF000080),
                // Colors.blue[900],
              ]),
        ),
        // color: Color(0xFFFFF1E9),
        child: Column(
          children: <Widget>[
            Flexible(flex: 2, child: RoomIdentity()),
            Flexible(flex: 4, child: JoiningList()),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                WaitingForFriends(),
              ],
            )),
            Flexible(flex: 2, child: Center(child: StartStatus())),
          ],
        ),
      ),
    );
  }
}

Future<void> updateDennerName() async {
  await FirebaseFirestore.instance
      .collection('rooms')
      .doc(documentid)
      .update({'den': players[playersId.indexOf(denId)]});
}
