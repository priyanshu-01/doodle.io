import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../selectRoom.dart';
import 'room.dart';
int roundsLimit = 3;
class DisplayRound extends StatefulWidget {
  @override
  _DisplayRoundState createState() => _DisplayRoundState();
}

class _DisplayRoundState extends State<DisplayRound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StepperSwipe(
        initialValue: roundsLimit,
        onChanged: (int val) {
          roundsLimit = val;
        },
        direction: Axis.horizontal,
        secondIncrementDuration: Duration(milliseconds: 500),
        withPlusMinus: true,
        dragButtonColor: Colors.pink,
        iconsColor: Colors.pink,
        speedTransitionLimitCount: 3,
      ),
    );

    Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 45.0,
            ),
            onPressed: () {
              (roundsLimit == 1)
                  ? null
                  : setState(() {
                      roundsLimit = roundsLimit - 1;
                    });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '$roundsLimit',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              size: 45.0,
            ),
            onPressed: () {
              (roundsLimit == 5)
                  ? null
                  : setState(() {
                      roundsLimit = roundsLimit + 1;
                    });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Rounds',
                style: TextStyle(
                  fontSize: 20.0,
                )),
          ),
        ],
      ),
    );
  }
}

class WaitingForFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Waiting for friends to join...',
              style: TextStyle(color: Color(0xFF45454D)),
            ),
            SpinKitThreeBounce(
                  color: Colors.black,
                  size: 20.0,
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
        onPressed: (counter > 1)
            ? () {
                game=true;
                startGame();
              }
            : null,
        disabledColor: Colors.pink[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
          child: Text('Start Game',
              style: GoogleFonts.notoSans(
                  color: Color(0xFFFFF1E9), fontSize: 20.0)),
        ),
        color: Color(0xFFFF4893),
      );
    else
      return Padding(
       padding: const EdgeInsets.only(top: 14.0, bottom: 12.0),
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Text('$host will start the Game',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.notoSans(color: Color(0xFFFF4893), fontSize: 20.0)),
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
      child: Container(
        width: totalWidth * 0.7,
        child: Card(
          elevation: 15.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                            border: Border.all(color: Color(0xFFFFD5D5)),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Color(0xFFFFD5D5),
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
                                    fontSize: 20.0, color: Color(0xFF45454D)),
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
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Text(
                            'Room id : $roomID',
                            style: GoogleFonts.quicksand(
                                fontSize: 25.0, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Share this with your firends',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(' and ask them to join!',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Color(0xFFFF4893),
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
                        border: Border.all(
                          color: Colors.white,
                          // width: 2.0
                        ),
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
      child: SafeArea(
        child: Container(
          color: Color(0xFFFFF1E9),
          child: Column(
            children: <Widget>[
              Flexible(flex: 2,child: RoomIdentity()),
              Flexible(flex: 4, child: JoiningList()),
              Flexible(child:   (identity == hostId)?DisplayRound():WaitingForFriends()),
              Flexible(flex: 2,child: StartStatus()),
            ],
          ),
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
