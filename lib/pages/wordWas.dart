import 'package:flutter/material.dart';
import 'package:scribbl/pages/painterScreen.dart';
import 'room.dart';
import 'package:quiver/async.dart';
import 'selectRoom.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

List sortedPlayers;
List sortedScore;

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

class WordWasContent extends StatefulWidget {
  @override
  _WordWasContentState createState() => _WordWasContentState();
}

class _WordWasContentState extends State<WordWasContent>
    with TickerProviderStateMixin {
  AnimationController controller;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    print(controller.value);
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget child) {
        return wordWasContent();
      },
    );
  }

  Widget wordWasContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child:
              // Text('The word was $word')
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Word was',
                style: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$word',
                style: GoogleFonts.notoSans(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            child: Center(
              child: ListView.builder(
                  itemCount: sortedPlayers.length,
                  //  itemCount: 10,
                  itemBuilder: (_, int a) {
                    String name = sortedPlayers[a];
                    //  int score = sortedScore[a]*controller.value;
                    double sc = sortedScore[a] * controller.value;
                    int score = sc.toInt();
                    return FractionallySizedBox(
                      widthFactor: 0.75,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              flex: 9,
                              child: Text('$name',
                                  style: GoogleFonts.notoSans(
                                      color: Colors.black,
                                      fontSize: totalWidth / 20,
                                      fontWeight: (name==userNam)?FontWeight.w800:FontWeight.normal
                                      )),
                            ),
                            //Text(':',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 20.0)),
                            Flexible(
                              flex: 4,
                              child: Text('+ $score',
                                  style: GoogleFonts.notoSans(
                                      color: (score == 0)
                                          ? Colors.red[800]
                                          : Colors.green[600],
                                      fontSize: totalWidth / 20)),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }

  void sort() {
    sortedPlayers = players;
    sortedScore = tempScore;
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
