import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
import 'package:scribbl/pages/Painter_screen/painterScreen.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'gameScreen.dart';
import '../Select_room/selectRoom.dart';
import '../../services/authHandler.dart';
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
Map roomData;
List chat = [];
bool flag = false;
String documentid;
List denChangeTrack;
Map<String, dynamic> record;
List allAttemptedWords = [];

class Room extends StatelessWidget {
  final int id;
  final Currency currency;
  Room({Key key, @required this.id, @required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<RoomData>(context);
    roomID = id;
    print('returned room');
    if (roomData == null)
      return Container();
    else {
      if (playersId.indexOf(identity) == -1 && !flag) {
        addPlayer();
      } //add player if not added

      if (game == false) {
        if (currency.coinsAmountColor != Colors.white) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            currency.coinsColor = Colors.black;
          });
        }
        return MeetingPage();
      } else {
        if (currency.coinsAmountColor != Colors.black) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            currency.coinsColor = Colors.black;
          });
        }
        return GameScreen();
      }
    }
    //   },
    // ),
  }
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

Future<void> removeMe() async {
  counter = counter - 1;
  int plInd = playersId.indexOf(identity);
  players.removeAt(plInd);
  playersId.removeAt(plInd);
  tempScore.removeAt(plInd);
  finalScore.removeAt(plInd);
  playersImage.removeAt(plInd);
  updatePlayerData();
  if (players.length == 0) {
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
          .updateData({'host': players[0], 'host_id': playersId[0]});
    }
    if (denId == identity) {
      changeDen('room.dart line 433');
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
