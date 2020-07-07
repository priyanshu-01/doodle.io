import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/Select_room/createRoom.dart';
import 'package:share/share.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
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
            color: Colors.yellow,
            size: 40.0,
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
      return RaisedButton(
          animationDuration: Duration(seconds: 1),
          onPressed: (counter > 1)
              ? () {
                  game = true;
                  startGame();
                }
              : null,
          disabledColor: Colors.grey[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
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
          color: Colors.green[700]
          // Color(0xFFFF4893),
          );
    else
      return Padding(
        padding: const EdgeInsets.only(top: 14.0, bottom: 12.0),
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Flexible(
            child: AutoSizeText('$host will start the Game',
                maxFontSize: 25.0,
                minFontSize: 10.0,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.notoSans(color: Colors.white, fontSize: 20.0)),
          ),
        ),
      );
  }

  Future<void> startGame() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'game': game, 'numberOfRounds': roundsLimit});
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
                  itemCount: counter,
                  itemBuilder: (BuildContext context, int a) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4.0, left: 4.0, right: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue[200],
                                  // Color(0xFFFFD5D5)
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.blue[200],
                                gradient: LinearGradient(colors: [
                                  Colors.blue[700],
                                  Colors.blue[300]
                                ])
                                //  Color(0xFFFFD5D5),
                                ),
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 9.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      backgroundImage:
                                          NetworkImage(playersImage[a]),
                                      radius: 20.0,
                                    )),
                                Text(
                                  players[a],
                                  style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  Divider(color: Color(0xFFFFEBCD),
                        //  thickness: 2.0,
                        //  indent: 60.0,
                        //  )
                      ],
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
                  fontSize: 20.0,
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
                    Share.share('Room id $roomID');
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
          gradient: RadialGradient(radius: 0.8, colors: [
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
            Flexible(child: Center(child: WaitingForFriends())),
            Flexible(flex: 2, child: Center(child: StartStatus())),
          ],
        ),
      ),
    );
  }
}

Future<void> updateDennerName() async {
  await Firestore.instance
      .collection('rooms')
      .document(documentid)
      .updateData({'den': players[playersId.indexOf(denId)]});
}
