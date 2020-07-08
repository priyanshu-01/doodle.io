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
// = [
//   'developer',
//   'dev',
//   'developer ksaalcalichaovo',
//   'devesdasloper',
//   'dedveloper',
//   'dedveloper',
//   'dedveloper',
// ];
List sortedScore;
// = [450, 450, 450, 450, 450, 100, 1000]; //CHANGE LATER

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
            currency.remainingCoins + tempScore[playersId.indexOf(denId)];
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
        guessersId = [];
        word = '*';
        print('WordWas 2 .... 5 seconds over');
      }
      changeDenIfNeeded();
      // setState(() {

      // });
      current = duration.elapsed.inSeconds;
    });
    sub.onDone(() {
      sub.cancel();
      //  changeDen();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Word was',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 20.0,
            //fontWeight: FontWeight.bold,
          ),
        ),
        AutoSizeText(
          '$word',
          //'$word',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 26.0,
            // fontWeight: FontWeight.bold,
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
  AnimationController controller;
  double sc;
  int score;
  @override
  void initState() {
    sort();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      // value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    controller.forward(from: 0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 5,
              child:
                  // Text('The word was $word')
                  const WordHeading()),
          Flexible(
            flex: 14,
            child: Container(
              child: ListView.builder(
                  itemCount: sortedPlayers.length,
                  //  itemCount: 10,
                  itemBuilder: (_, int a) {
                    String name = sortedPlayers[a];
                    //  int score = sortedScore[a]*controller.value;

                    int b = a + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.65,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey[200]),
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
                                              color: Colors.black,
                                              fontSize: totalWidth / 20,
                                              // fontSize: 300 / 20, //CHANGE LATER

                                              fontWeight: (name == userNam)
                                                  ? FontWeight.w800
                                                  : FontWeight.normal)),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Flexible(
                                        child: AutoSizeText('$name',
                                            maxLines: 1,
                                            style: GoogleFonts.notoSans(
                                                color: Colors.black,
                                                fontSize: totalWidth /
                                                    20, //CHANGE LATER
                                                // fontSize:
                                                // 300 / 20, //CHANGE LATER

                                                fontWeight: (name == userNam)
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
                                    builder:
                                        (BuildContext context, Widget child) {
                                      sc = sortedScore[a] * controller.value;
                                      score = sc.toInt();
                                      return
                                          // Temp();

                                          Row(
                                        children: [
                                          Text('+ $score',
                                              style: GoogleFonts.notoSans(
                                                  color: (score == 0)
                                                      ? Colors.red[800]
                                                      : Colors.green[600],
                                                  fontSize: totalWidth /
                                                      20 //  CHANGE LATER
                                                  // fontSize: 300 / 20
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
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  void sort() {
    sortedPlayers = players.sublist(0);
    sortedScore = tempScore.sublist(0);
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
}
