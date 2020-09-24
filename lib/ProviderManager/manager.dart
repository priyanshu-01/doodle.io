import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scribbl/OverlayManager/informationOverlayBuilder.dart';
import 'package:scribbl/pages/Guesser_screen/countDown.dart';
import 'package:scribbl/pages/Guesser_screen/guesserScreen.dart';
import 'package:scribbl/pages/Painter_screen/painterCountDown.dart';
import 'package:scribbl/pages/Select_room/createRoom.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/result.dart';
import 'package:scribbl/pages/room/room.dart';
import 'package:scribbl/reactions/listenReactions.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'package:scribbl/virtualCurrency/virtualCurrency.dart';
import 'data.dart';
import 'package:flutter/foundation.dart';
import '../pages/Guesser_screen/guesser.dart';

Map cacheRoomData;
GuesserCountDown guesserCountDown;
PainterCountDown painterCountDown;
RoomData myRoomData;
GameScreenData gameScreenData;
ChatData chatData;
GuessersIdData guessersIdData;
CustomPainterData customPainterData;

List displayNames;
List displayScores;
String docId;

class Manager extends StatefulWidget {
  final int id;
  final Currency currency;
  final GlobalKey key;
  Manager({this.key, @required this.id, @required this.currency})
      : super(key: key);

  @override
  _ManagerState createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  StreamSubscription<DocumentSnapshot> firestoreRoomDataSubscription;
  @override
  void initState() {
    guesserCountDown = GuesserCountDown();
    painterCountDown = PainterCountDown();
    reactionListener = ReactionListener();
    //FirebaseFirestore Builders below
    myRoomData = RoomData();
    gameScreenData = GameScreenData();
    chatData = ChatData();
    guessersIdData = GuessersIdData();
    customPainterData = CustomPainterData();
    // game = false;
    denChangeTrack = [];
    if (roomData['userData'].containsKey(identity) &&
        roomData['userData'][identity]['myStatus'] == 'joined' &&
        playersId.indexOf(identity) == -1) {
      addPlayer();
    } //add player if not added
    reactionListener.updateReactionRecord();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   reactionListener.listenReactions(context);
    // });
    firestoreRoomDataSubscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(documentid)
        .snapshots()
        .listen((event) {
      cacheRoomData = roomData;
      roomData = event.data();
      readRoomData();
      if (round > numberOfRounds) {
        docId = documentid;
        displayNames = players;
        displayScores = getFinalScores(finalScore, playersId.sublist(0));
        setState(() {});
      } else {
        if (cacheRoomData == null)
          myRoomData.rebuildRoom();
        else
          rebuildMinimumWidgets();
        reactionListener.listenReactions(context);
      }
    });
    super.initState();
  }

  List getFinalScores(Map finalScore, List playersIdList) {
    List finalScoreList = [];
    for (var playerId in playersIdList) {
      finalScoreList.add(finalScore[playerId]);
    }
    return finalScoreList;
  }

  @override
  Widget build(BuildContext context) {
    if (round > numberOfRounds) {
      firestoreRoomDataSubscription.cancel();
      return Result();
    } else
      return WillPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
                child: MultiProvider(
                    providers: [
                  ChangeNotifierProvider.value(value: widget.currency),
                  ChangeNotifierProvider(
                    create: (context) => guesserCountDown,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => painterCountDown,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => myRoomData,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => gameScreenData,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => chatData,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => guessersIdData,
                  ),
                  ChangeNotifierProvider(
                    create: (context) => customPainterData,
                  )
                ],
                    child: Stack(
                      children: [
                        Room(
                          id: widget.id,
                          currency: widget.currency,
                        ),
                        Positioned(
                            right: 0.0, top: 0.0, child: VirtualCurrency()),
                      ],
                    ))

                //

                ),
          ),
          onWillPop: () =>
              leaveRoomAlert(context, firestoreRoomDataSubscription));
  }

  @override
  void dispose() {
    firestoreRoomDataSubscription.cancel();
    super.dispose();
  }

  Future<bool> leaveRoomAlert(BuildContext context,
      StreamSubscription firestoreRoomDataSubscription) async {
    Alert(
      content: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          InkWell(
            enableFeedback: false,
            child: OverlayButton(
              label: 'Leave',
              size: 20.0,
              padding: 16.0,
            ),
            onTap: () {
              audioPlayer.playSound('click');
              firestoreRoomDataSubscription.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
              removeMe();
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
              enableFeedback: false,
              child: OverlayButton(
                label: 'Stay',
                size: 20.0,
                padding: 20.0,
              ),
              onTap: () {
                audioPlayer.playSound('click');
                Navigator.pop(context);
              })
        ],
      ),
      context: context,
      type: AlertType.none,
      title: "Leave Room ?",
      style: AlertStyle(
          titleStyle: myCoustomOverlayTextStyle(size: 25.0),
          backgroundColor: Colors.blue[700],
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 200),
          alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      buttons: [],
    ).show();
    return true;
  }
}

void readRoomData() {
  // should rebuild room
  game = roomData['game'];
  counter = roomData['counter'];
  players = roomData['users'];
  playersId = roomData['users_id'];
  playersImage = roomData['usersImage'];
  host = roomData['host'];
  hostId = roomData['host_id'];

  //should rebuild game screen
  denId = roomData['den_id'];
  denner = roomData['den'];
  denCanvasLength = roomData['denCanvasLength'];
  word = roomData['word'];
  wordChosen = roomData['wordChosen'];
  round = roomData['round'];

  //should rebuild chatList and popUpChat
  // roomData['$identity Chat'];
  chat = roomData['chat'];

  //should rebuild stackChild ---- guesser
  // '$identity': '$denId $round',

  guessersId = roomData['guessersId'];
  tempScore = roomData['tempScore'];
  finalScore = roomData['finalScore'];

  //should rebuild guesser/painter
  //if pointer changes

  (roomData['userData'] != null &&
          roomData['userData'][identity] != null &&
          roomData['userData'][identity]['denChangeTrack'] != null)
      ? denChangeTrack = roomData['userData'][identity]['denChangeTrack']
      : denChangeTrack = [];
  numberOfRounds = roomData['numberOfRounds'];
  allAttemptedWords = roomData['allAttemptedWords'];
}

void rebuildMinimumWidgets() {
  if (roomData['game'] != cacheRoomData['game'] ||
      roomData['counter'] != cacheRoomData['counter'] ||
      !listEquals(roomData['users_id'], cacheRoomData['users_id']) ||
      roomData['host_id'] != cacheRoomData['host_id']) {
    reactionListener.updateReactionRecord();
    if (roomData['userData'].containsKey(identity) &&
        roomData['userData'][identity]['myStatus'] == 'joined' &&
        playersId.indexOf(identity) == -1) {
      addPlayer();
    }
    print('rebuilding room');
    myRoomData.rebuildRoom();
  } else if (roomData['den_id'] != cacheRoomData['den_id'] ||
      roomData['denCanvasLength'] != cacheRoomData['denCanvasLength'] ||
      roomData['word'] != cacheRoomData['word'] ||
      roomData['round'] != cacheRoomData['round']) {
    print('rebuilding game screen');
    gameScreenData.rebuildGameScreen();
  } else if (roomData['userData'][identity]['lastGuess'] !=
          cacheRoomData['userData'][identity]['lastGuess'] ||
      !mapEquals(roomData['guessersId'], cacheRoomData['guessersId'])) {
    print('rebuilding guessers');
    audioPlayer.playSound('someoneGuessed');
    guessersIdData.rebuildGuessersId();
  } else if (roomData['userData'][identity]['lastMessageIndex'] !=
          cacheRoomData['userData'][identity]['lastMessageIndex'] ||
      !listEquals(roomData['chat'], cacheRoomData['chat'])) {
    print('rebuilding chat');
    chatData.rebuildChat();
  } else if (roomData['pointer'] != cacheRoomData['pointer']) {
    print('rebuilding custom painters');
    compute(parseGuesserStrokesData, {
      'roomData': roomData,
      'denCanvasLength': denCanvasLength,
      'guessCanvasLength': guessCanvasLength,
      'pointerVal': pointerVal
    }).then((value) {
      pointsG = value['pointsG'];
      ind1 = value['ind1'];
      ind2 = value['ind2'];
      pStore = value['pStore'];
      pointerVal = value['pointerVal'];
      customPainterData.rebuildGuesserCustomPainter();
    });
  }
}
