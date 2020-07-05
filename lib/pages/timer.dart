import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/pages/Guesser_screen/countDown.dart';
import 'Painter_screen/painterCountDown.dart';
import 'room/room.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  @override
  Widget build(BuildContext context) {
    var painterCountDown = Provider.of<PainterCountDown>(context);
    return Container(
      child: Text(
        painterCountDown.current.toString(),
        style: GoogleFonts.lexendGiga(),
      ),
    );
  }
}

class TimeAndWord extends StatefulWidget {
  @override
  _TimeAndWordState createState() => _TimeAndWordState();
}

class _TimeAndWordState extends State<TimeAndWord> {
  int current = 0;
  List<int> places = new List();
  List<int> revealed = [];
  int counter = 0;
  int q = 0, w = 0, e = 0, r = 0;
  @override
  void initState() {
    places = getClues();
    initialiseTime();
    super.initState();
  }

  void addRevealedLettersIfNeeded() {
    if (current == q) {
      revealed.add(places[counter++]);
    } else if (current == w) {
      if (places.length > 1) {
        revealed.add(places[counter++]);
      }
    } else if (current == e) {
      if (places.length > 2) {
        revealed.add(places[counter++]);
      }
    } else if (current == r) {
      if (places.length > 3) {
        revealed.add(places[counter++]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var guesserCountDown = Provider.of<GuesserCountDown>(context);
    current = guesserCountDown.current - 2;
    addRevealedLettersIfNeeded();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '$current',
          style: GoogleFonts.lexendGiga(),
        ),
        WordHint(
          revealed: revealed,
        )
      ],
    );
  }

  List<int> getClues() {
    List<int> place = List();
    int l = word.length;
    int div = l ~/ 4;
    int i;
    double r;
    int k;
    for (i = 0; i < div; i++) {
      r = Random().nextDouble();
      r = (r * 4);
      k = r.toInt();
      if (word[(i * 4) + k] != ' ')
        place.add((i * 4) + k);
      else
        place.add((i * 4) + k + 1);
    }
    if (l % 4 != 0) {
      int rem;
      rem = l % 4;
      r = Random().nextDouble();
      r = (r * rem);
      k = r.toInt();
      if (word[(div * 4) + k] != ' ')
        place.add((div * 4) + k);
      else
        place.add((div * 4) + k + 1);
    }
    return place;
  }

  void initialiseTime() {
    //errorsq
    int len = word.length;
    if (len <= 4) {
      q = 60;
    } else if (len <= 8) {
      q = 65;
      w = 40;
    } else if (len <= 12) {
      q = 70;
      w = 50;
      e = 30;
    } else {
      q = 75;
      w = 60;
      e = 35;
      r = 15;
    }
  }
}

class WordHint extends StatelessWidget {
  final List revealed;
  WordHint({this.revealed});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: word.length / 17,
        child: Container(
          //alignment: Alignment.bottomCenter,
          //color: Colors.orange[50],
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: word.length,
              itemBuilder: (_, int h) {
                if (word.indexOf(' ') == h) {
                  return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '  ',
                        style: TextStyle(fontSize: 15.0),
                      ));
                } else {
                  if (revealed.indexOf(h) == -1) {
                    return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '_ ',
                          style: TextStyle(fontSize: 15.0),
                        ));
                  } else {
                    String rev = word[h];
                    return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '$rev ',
                          style: TextStyle(fontSize: 15.0),
                        ));
                  }
                }
              }),
        ),
      ),
    );
  }
}
