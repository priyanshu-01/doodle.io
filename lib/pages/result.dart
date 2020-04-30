import 'package:flutter/material.dart';
import 'gameScreen.dart';
class Result extends StatelessWidget {
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