import 'package:flutter/material.dart';
import 'package:scribbl/pages/room.dart';
import 'gameScreen.dart';
class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
          body: Center(
        child: Container(
          height: 400.0,
          child:ListView.builder(
                  itemCount: displayNames.length,
                  itemBuilder: (_,int a){
                    String name= displayNames[a];
                    int score=displayScores[a];
                    return Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text('$name'),
                        Text(':'),
                        Text('$score')
                      ],),
                    );
                  }),
          
        ),
      ),
    );
  }
}