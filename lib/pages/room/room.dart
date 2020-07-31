import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
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
Map roomData;
List chat = [];
bool flag = false;
String documentid;
List denChangeTrack = [];
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
      if (game == false) {
        if (currency.coinsAmountColor != Colors.white) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            currency.coinsColor = Colors.white;
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
  updatePlayerData('joined');
  flag = true;
}

Future<void> removeMe() async {
  counter = counter - 1;
  int myIndex = playersId.indexOf(identity);
  players.removeAt(myIndex);
  playersId.removeAt(myIndex);
  tempScore.removeAt(myIndex);
  finalScore.removeAt(myIndex);
  playersImage.removeAt(myIndex);
  updatePlayerData('left').then((value) async {
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
            .updateData(
                {'host': players[0], 'host_id': playersId[0]}).whenComplete(() {
          if (denId == identity)
            changeDenWhileLeaving('room.dart line 433', myIndex);
        });
      } else if (denId == identity) {
        changeDenWhileLeaving('room.dart line 433', myIndex);
      }
    }
  });
}

Future<void> updatePlayerData(String myStatus) async {
  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'users': players,
    'counter': counter,
    'users_id': playersId,
    'tempScore': tempScore,
    'finalScore': finalScore,
    'usersImage': playersImage,
    'userData.$identity': {
      'name': userNam,
      'myStatus': myStatus,
      'lastGuess': '',
      'lastMessageIndex': null,
      'denChangeTrack': denChangeTrack,
      'lastReaction': null,
    }
  });
}

Future<void> changeDenWhileLeaving(String source, int myIndex) async {
  record = {
    'name': userNam,
    'beforeChangeDenId': denId,
    'beforeChangeDenName': userNam,
    'round': round,
    'myIndex': 'left',
    'indexOfDenner': 'left',
    'word': word,
    'source': source,
    'guessersId': guessersId,
    'no. of guessers': guessersId.length
  };
  denChangeTrack = denChangeTrack + [record];
  word = '*';
  int s = myIndex - 1;
  if (s == players.length - 1) {
    s = 0;
    round = round + 1;
  } else
    s = s + 1;
  for (int k = 0; k < tempScore.length; k++) {
    tempScore[k] = 0;
  }

  await Firestore.instance.collection('rooms').document(documentid).updateData({
    'den': players[s],
    'den_id': playersId[s],
    'xpos': {},
    'ypos': {},
    'word': '*',
    'length': 0,
    'wordChosen': false,
    'indices': [0],
    'colorIndexStack': [0],
    'pointer': 0,
    'guessersId': [],
    'tempScore': tempScore,
    'round': round,
    'userData.$identity.denChangeTrack': denChangeTrack
  });
}
