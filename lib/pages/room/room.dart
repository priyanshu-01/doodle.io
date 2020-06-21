import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribbl/pages/Painter_screen/painterScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../gameScreen.dart';
import '../selectRoom.dart';
import '../../services/authHandler.dart';
import '../Guesser_screen/guesserScreen.dart';
import '../../reactions/listenReactions.dart';
import 'meetingPage.dart';
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
Map roomData = {};
List chat = [];
bool flag = false;
String documentid;
List denChangeTrack;
Map<String, dynamic> record;

class CreateRoom extends StatefulWidget {
  final int id;
  CreateRoom({Key key, this.id}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  void initState() {
    game=false;
    reactionListener = ReactionListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    roomID = widget.id;
    print('returned room');
    return WillPopScope(
        child: Scaffold(
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('rooms')
                  .where('id', isEqualTo: roomID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  reactionListener.listenReactions(context);
                });
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot == null)
                  return Container();
                else {
                  readRoomData(snapshot);

                  if (playersId.indexOf(identity) == -1 && !flag) {
                    addPlayer();
                  }

                  if (roomData[identity] == '$denId $round' &&
                      guessersId.indexOf(identity) == -1) {
                    updateScore();
                  }
                  //    if(denner!=players[playersId.indexOf(denId)] && identity==hostId)   //error by crashlytics
                  //  updateDennerName();
                  if (game == false)
                    return MeetingPage();
                  else {
                    return GameScreen();
                  }
                }
              },
            ),
          ),
        ),
        onWillPop: () {
          leaveRoomAlert(context, players, counter);
        });
  }

  void readRoomData(AsyncSnapshot<QuerySnapshot> snapshot) {
    roomData = snapshot.data.documents[0].data;
    documentid = snapshot.data.documents[0].documentID;
    counter = roomData['counter'];
    players = roomData['users'];
    host = roomData['host'];
    game = roomData['game'];
    denner = roomData['den'];
    word = roomData['word'];
    chat = roomData['chat'];
    playersId = roomData['users_id'];
    playersImage = roomData['usersImage'];
    hostId = roomData['host_id'];
    denId = roomData['den_id'];
    wordChosen = roomData['wordChosen'];
    guessersId = roomData['guessersId'];
    tempScore = roomData['tempScore'];
    finalScore = roomData['finalScore'];
    round = roomData['round'];
    (roomData['$identity denChangeTrack'] != null)
        ? denChangeTrack = roomData['$identity denChangeTrack']
        : denChangeTrack = [];
    denCanvasLength = roomData['denCanvasLength'];
    numberOfRounds = roomData['numberOfRounds'];
  }

  void addPlayer() {
    players = players + [userNam];
    counter = counter + 1;
    playersId = playersId + [identity];
    tempScore = tempScore + [0];
    finalScore = finalScore + [0];
    playersImage = playersImage + [imageUrl];
    updatePlayerData();
    flag = true;
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
    List playerRemoved = players;
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