import 'package:flutter/material.dart';
import 'package:scribbl/pages/room.dart';
import 'gameScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectRoom.dart';

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ResultContent();
  }
}

class ResultContent extends StatefulWidget {
  @override
  _ResultContentState createState() => _ResultContentState();
}


class _ResultContentState extends State<ResultContent>  with TickerProviderStateMixin {
  List sortedPlayers;
  List sortedScore;
  AnimationController controller;
  @override
  void initState() {
    sort();
     controller= AnimationController(
      vsync: this,
    duration: Duration(seconds: 02),
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
      builder: (BuildContext context, Widget child){
       return resultContent();
      },
      );
  }
Widget resultContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Flexible(
        flex: 1,
        child:
            // Text('The word was $word')
            Text(
          'Doodle.io',
          style: GoogleFonts.notoSans(color: Colors.black, fontSize: 25.0),
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
                double sc= sortedScore[a]*controller.value;
                 int  score= sc.toInt();
                  return FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('$name',
                              style: GoogleFonts.notoSans(
                                  color: Colors.black, fontSize: effectiveLength/28)),
                          //Text(':',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 20.0)),
                          Text('+ $score',
                              style: GoogleFonts.notoSans(
                                  color: (score == 0)
                                      ? Colors.red[800]
                                      : Colors.green[600],
                                  fontSize: effectiveLength/28))
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
  sortedPlayers = displayNames;
  sortedScore = displayScores;
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