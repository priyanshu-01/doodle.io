import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/painterScreen.dart';
import 'selectRoom.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'gameScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import '../services/authHandler.dart';
import 'guesserScreen.dart';
import '../reactions/listenReactions.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
bool game;
bool wordChosen;
String host;
int counter;
List players = new List();
List playersImage = List();
int roomID;
String denner;
String word;
String hostId;
String denId;
List playersId = new List();
List guessersId = new List();
List tempScore = new List();
List finalScore = new List();
int round = 1;
double denCanvasLength;
int numberOfRounds = 3;
Map a={};
List chat = [];
bool flag = false;
String documentid;
List denChangeTrack;
Map<String,dynamic> record;
class CreateRoom extends StatefulWidget {
  final int id;
   CreateRoom({Key key, this.id}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
void initState() { 
  reactionListener=ReactionListener();
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    roomID = widget.id;
    // if(round>numberOfRounds)
    // {print('should return result');
    // return Result();}
    // else
    print('returned room');
    return WillPopScope(
        child: Scaffold(
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('rooms')
                  .where('id', isEqualTo: widget.id)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                   reactionListener.listenReactions(context);
                  });
                if (snapshot.connectionState==ConnectionState.waiting || snapshot == null  ) return Container();
                 else{
                a = snapshot.data.documents[0].data;
                documentid = snapshot.data.documents[0].documentID;
                counter = a['counter'];
                players = a['users'];
                host = a['host'];
                game = a['game'];
                denner = a['den'];
                word = a['word'];
                chat = a['chat'];
                playersId = a['users_id'];
                playersImage = a['usersImage'];
                hostId = a['host_id'];
                denId = a['den_id'];
                wordChosen = a['wordChosen'];
                guessersId = a['guessersId'];
                tempScore = a['tempScore'];
                finalScore = a['finalScore'];
                round = a['round'];
                (a['$identity denChangeTrack']!=null)?
                denChangeTrack = a['$identity denChangeTrack']:denChangeTrack=[];
                denCanvasLength = a['denCanvasLength'];
                numberOfRounds = a['numberOfRounds'];
                if (playersId.indexOf(identity) == -1 && !flag) {
                  players = players + [userNam];
                  counter = counter + 1;
                  playersId = playersId + [identity];
                  tempScore = tempScore + [0];
                  finalScore = finalScore + [0];
                  playersImage = playersImage + [imageUrl];
                  updatePlayerData();
                  flag = true;
                }
                if (a
                            [identity] ==
                        '$denId $round' &&
                    guessersId.indexOf(
                            identity) ==
                        -1) {
                 
                  updateScore();
                }
            //    if(denner!=players[playersId.indexOf(denId)] && identity==hostId)   //error by crashlytics
              //  updateDennerName();
                if (game == false)
                  return Center(
                    child: Container(
                      color: Color(0xFFFFF1E9),
                      child: SafeArea(
                        child: Container(
                          //color: Colors.red[800],
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Container(
                                  //alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12.0),
                                        child: Text(
                                          'Room id : ${widget.id}',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 25.0,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
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
                                                    style:
                                                        GoogleFonts.quicksand(
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
                                                Share.share('Room id $roomID'
                                                );
                                              },
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Card(
                                      elevation: 15.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: ListView.builder(
                                            itemCount: snapshot
                                                .data.documents[0]['counter'],
                                            itemBuilder:
                                                (BuildContext context, int a) {
                                              return Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4.0,
                                                            left: 4.0,
                                                            right: 4.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFFFD5D5)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        color:
                                                            Color(0xFFFFD5D5),
                                                      ),
                                                      child: Row(
                                                        // mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20.0,
                                                                      vertical:
                                                                          9.0),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        100],
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        playersImage[
                                                                            a]),
                                                                radius: 20.0,
                                                              )),
                                                          Text(
                                                            players[a],
                                                            style: GoogleFonts
                                                                .notoSans(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Color(
                                                                        0xFF45454D)),
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
                              ),
                              Flexible(child: roundNumberOrWaiting()),
                              Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14.0, bottom: 12.0),
                                    child: startStatus(),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                else{
                   return gameScreen();

                }
                  }
              },
            ),
          ),
        ),
        onWillPop: () {
          leaveRoomAlert(context, players, counter);
       //   return;
        });
    //funct(id);
  }

  Widget roundNumberOrWaiting() {
    if (identity == hostId) {
      return DisplayRound();
    } else
      //return DisplayRound();
      return Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Waiting for friends to join...',
            style: TextStyle(color: Color(0xFF45454D)),
          ),
          SpinKitThreeBounce(
            color: Colors.black,
            size: 20.0,
          )
        ],
      );
  }

  Widget startStatus() {
    if (identity == hostId)
      return RaisedButton(
        onPressed: (counter > 1)
            ? () {
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
      return FractionallySizedBox(
        widthFactor: 0.7,
        child: Text('$host will start the Game',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.notoSans(color: Color(0xFFFF4893), fontSize: 20.0)),
      );
  }

  void leaveRoomAlert(BuildContext context, List players, int counter) {
    Alert(
      content: SizedBox(
        height: 50.0,
      ),
      context: context,
      type: AlertType.none,
      title: "Leave Room ?",
      style: AlertStyle(
          backgroundColor: Color(0xFFFFF1E9),
          //backgroundColor: Colors.red[600],
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 200),
          alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      buttons: [
        DialogButton(
          // width: 40.0,
          radius: BorderRadius.circular(20.0),
          child: Text(
            "Leave",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Color(0xFFFF4893),
          onPressed: () {
            Navigator.pop(context);
            // if (hostId != identity) {
            //   Navigator.pop(context);
            // }
            Navigator.pop(context);
            removeMe();
          },
          // color: Colors.white,
        ),
        DialogButton(
          radius: BorderRadius.circular(20.0),
          child: Text(
            "Stay",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        )
      ],
    ).show();
  }

  Future<void> removeMe() async {
    List  playerRemoved = players;
    List identityRemoved = playersId;
    List tempScoreRemoved = tempScore;
    List finalScoreRemoved = finalScore;
    int count = counter - 1;
    int plInd = playersId.indexOf(identity);
    playerRemoved.removeAt(plInd);
    identityRemoved.removeAt(plInd);
    tempScoreRemoved.removeAt(plInd);
    finalScoreRemoved.removeAt(plInd);
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({
      'users': playerRemoved,
      'counter': count,
      'users_id': identityRemoved,
      'tempScore': tempScoreRemoved,
      'finalScore': finalScoreRemoved
    });
    if (playerRemoved.length == 0) {
      // del doc
      await Firestore.instance
          .collection('rooms')
          .document(documentid)
          .delete()
          .catchError((e) {
        print(e);
        print('its an error');
      });
    } else {
      if (hostId == identity) {
        await Firestore.instance
            .collection('rooms')
            .document(documentid)
            .updateData(
                {'host': playerRemoved[0], 'host_id': identityRemoved[0]});
      }
      if (denId == identity) {
        changeDen('room.dart line 433');
      }
    }
  }

  Future<void> startGame() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'game': true, 'numberOfRounds': r});
  }
}

class DisplayRound extends StatefulWidget {
  @override
  _DisplayRoundState createState() => _DisplayRoundState();
}

int r = 3;

class _DisplayRoundState extends State<DisplayRound> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: StepperSwipe(
        initialValue: r,
       onChanged: (int val){r=val;},
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
              (r == 1)
                  ? null
                  : setState(() {
                      r = r - 1;
                    });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '$r',
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
              (r == 5)
                  ? null
                  : setState(() {
                      r = r + 1;
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

Future<void> updatePlayerData() async {
  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'users': players,
    'counter': counter,
    'users_id': playersId,
    'tempScore': tempScore,
    'finalScore': finalScore,
    'usersImage': playersImage
  });
}
Future<void> updateDennerName() async{
  await Firestore.instance.collection('rooms').document(documentid).updateData({
     'den': players[playersId.indexOf(denId)]
  });
}