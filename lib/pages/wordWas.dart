import 'package:flutter/material.dart';
import 'package:scribbl/pages/Painter_screen/painterScreen.dart';
import 'package:scribbl/services/authHandler.dart';
import 'Guesser_screen/guesserScreen.dart';
import 'room/room.dart';
import 'package:quiver/async.dart';
import 'Select_room/selectRoom.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'package:auto_size_text/auto_size_text.dart';

List sortedPlayers;
//  = [
//   'developer',
//   'dev',
//   'developer ksaalcalichaovo',
//   'devesdasloper',
//   'dedveloper',
//   'dedveloper',
//   'dedveloper',
//   'dedveloper',
//   'dedveloper',
// ];
List sortedScore;
//  = [450, 0, 450, 450, 450, 100, 1000, 1000, 10]; //CHANGE LATER

class WordWas extends StatefulWidget {
  @override
  _WordWasState createState() => _WordWasState();
}

class _WordWasState extends State<WordWas> {
  int current = 0;
  int end = 30 + (counter * 2);
  var sub;
  @override
  void initState() {
    current = 0;
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (identity == denId) {
        currency.setCoins =
            currency.remainingCoins + tempScore[denId]; //error by crashlytics
      } else {
        currency.setCoins = currency.remainingCoins + score;
        score = 0;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    current = 0;
    sub.cancel();
    print('word was is disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WordWasContent();
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: end),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if (current == 5) {
        changeDenIfNeeded();
        guessersId = {};
        word = '*';
        print('WordWas.... 5 seconds over');
      } else
        changeDenIfNeeded();
      current = duration.elapsed.inSeconds;
    });
    sub.onDone(() {
      sub.cancel();
    });
  }

  void changeDenIfNeeded() {
    int distance;
    int d = playersId.indexOf(denId);
    int m = playersId.indexOf(identity);
    if (d <= m) {
      distance = m - d;
    } else {
      distance = counter + m - d;
    }
    if (current == 5 + (distance * 3) && resumed && online)
      changeDen('wordWas.dart line 76 and vlaue of current is $current');
  }
}

class WordHeading extends StatelessWidget {
  const WordHeading();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Word was',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        AutoSizeText(
          // 'word',
          '$word',
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 26.0,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class WordWasContent extends StatefulWidget {
  @override
  _WordWasContentState createState() => _WordWasContentState();
}

class _WordWasContentState extends State<WordWasContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  var addItemsToList;
  AnimationController controller;
  double sc;
  int score;
  Duration insertDuration;
  int addItem;
  Color wordContainerColor;
  Color listContainerBorderColor;
  int listAnimationDurationMilliseconds;
  @override
  void initState() {
    wordContainerColor = Colors.white;
    listContainerBorderColor = Colors.white;
    addItem = 0;
    listAnimationDurationMilliseconds = playersId.length
        // sortedPlayers.length
        *
        200;
    if (listAnimationDurationMilliseconds > 1000)
      listAnimationDurationMilliseconds = 1000;
    sort(); //CHANGE LATER
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        wordContainerColor = Color(0xFF1f1f1f);
        listContainerBorderColor = Color(0xFF1f1f1f);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startTimer();
        });
      });
    });
    super.initState();
  }

  void _startTimer() {
    insertDuration = Duration(
        milliseconds:
            (listAnimationDurationMilliseconds / (sortedPlayers.length))
                .floor());
    CountdownTimer countDownTimer = new CountdownTimer(
        new Duration(milliseconds: listAnimationDurationMilliseconds + 200),
        new Duration(
            milliseconds:
                (listAnimationDurationMilliseconds / (sortedPlayers.length))
                    .floor()));

    addItemsToList = countDownTimer.listen(null);

    addItemsToList.onData((duration) {
      if (addItem < sortedPlayers.length) {
        _listKey.currentState.insertItem(addItem++, duration: insertDuration);
      }
    });

    addItemsToList.onDone(() {
      controller.forward(from: 0.0);
      addItem = 0;
      addItemsToList.cancel();
    });
  }

  @override
  void dispose() {
    if (controller != null) controller.dispose();
    if (addItemsToList != null) addItemsToList.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 5,
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                        color: wordContainerColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )),
                    child: const WordHeading()),
              )),
          Flexible(
            flex: 14,
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0, color: listContainerBorderColor)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: AnimatedList(
                      key: _listKey,
                      physics: BouncingScrollPhysics(),
                      initialItemCount: 0,
                      itemBuilder: (_, int a, Animation animation) {
                        String name = sortedPlayers[a];
                        int b = a + 1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.vertical,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF1f1f1f),
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 9,
                                        child: Row(
                                          children: [
                                            Text('$b',
                                                style: GoogleFonts.notoSans(
                                                    color: Colors.white,
                                                    fontSize: totalWidth / 20,
                                                    // fontSize:
                                                    //     300 / 20, //CHANGE LATER

                                                    fontWeight: (name ==
                                                            myUserName)
                                                        ? FontWeight.w800
                                                        : FontWeight.normal)),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Flexible(
                                              child: AutoSizeText('$name',
                                                  maxLines: 1,
                                                  style: GoogleFonts.notoSans(
                                                      color: Colors.white,
                                                      fontSize: totalWidth / 20,
                                                      //CHANGE LATER
                                                      // fontSize: 300 /
                                                      //     20, //CHANGE LATER

                                                      fontWeight: (name ==
                                                              myUserName)
                                                          ? FontWeight.w800
                                                          : FontWeight.normal)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        child: AnimatedBuilder(
                                          animation: controller,
                                          builder: (BuildContext context,
                                              Widget child) {
                                            sc = sortedScore[a] *
                                                controller.value;
                                            score = sc.toInt();
                                            return Row(
                                              children: [
                                                Text('+ $score',
                                                    style: GoogleFonts
                                                        // .notoSans
                                                        // .fredokaOne
                                                        .ubuntu(
                                                      // letterSpacing: 1.0,
                                                      color: (score == 0)
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: totalWidth / 20,
                                                      // CHANGE LATER
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      // fontSize:
                                                      //     300 / 20
                                                    )),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void sort() {
    sortedPlayers = players.sublist(0);
    sortedScore = getTempScores(tempScore, playersId.sublist(0));
    int temp;
    String temp2;
    for (int x = 0; x < sortedScore.length - 1; x++) {
      for (int y = x + 1; y < sortedScore.length; y++) {
        if (sortedScore[x] < sortedScore[y]) {
          temp = sortedScore[x];
          sortedScore[x] = sortedScore[y];
          sortedScore[y] = temp;

          temp2 = sortedPlayers[x];
          sortedPlayers[x] = sortedPlayers[y];
          sortedPlayers[y] = temp2;
        }
      }
    }
  }

  List getTempScores(Map tempScore, List playersIdList) {
    List tempScoreList = [];
    for (var playerId in playersIdList) {
      tempScoreList.add(tempScore[playerId]);
    }
    return tempScoreList;
  }
}
