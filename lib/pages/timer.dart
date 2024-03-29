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
        style: GoogleFonts.lexendGiga(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class TimeAndWord extends StatefulWidget {
  @override
  _TimeAndWordState createState() => _TimeAndWordState();
}

class _TimeAndWordState extends State<TimeAndWord> {
  int current;
  List<int> places = new List();
  List<int> revealed;
  int counter;
  int q, w, e, r;
  @override
  void initState() {
    current = 0;
    counter = 0;
    revealed = [];
    q = 0;
    w = 0;
    e = 0;
    r = 0;
    places = getClues();
    initialiseTime();
    super.initState();
  }

  void addRevealedLettersIfNeeded() {
    if (current == q && counter == 0) {
      revealed.add(places[counter++]); //error
    } else if (current == w && counter == 1) {
      if (places.length > 1) {
        revealed.add(places[
            counter++]); //error here places is short and counter goes out of bound;
      }
    } else if (current == e && counter == 2) {
      if (places.length > 2) {
        revealed.add(places[counter++]);
      }
    } else if (current == r && counter == 3) {
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
          style: GoogleFonts.lexendGiga(fontWeight: FontWeight.w800),
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
  String rev;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int h = 0; h < word.length; h++)
              (word[h] == ' ')
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        '  ',
                        style: TextStyle(fontSize: 15.0),
                      ))
                  : (assignRevValue(h))
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            '_ ',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w800),
                          ))
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$rev ',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w800),
                          ))
          ]),
    );
  }

  bool assignRevValue(int h) {
    if (revealed.indexOf(h) == -1) {
      return true;
    } else {
      rev = word[h];
      return false;
    }
  }
}
