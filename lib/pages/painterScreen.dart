import 'package:flutter/material.dart';
import 'package:scribbl/pages/gameScreen.dart';
import 'package:scribbl/pages/timer.dart';
import 'painter.dart';
import 'gameScreen.dart';
import 'room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chooseWord.dart';
class PainterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
                      child: Container(
              //constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    Text('Your word : $choosenWord'),
                //Time_denner(),
                // Text('67'),
                  ],),
                

                Container(child: Painter(),
                // decoration: BoxDecoration(
                //   border: Border.all(),
                //   color: Colors.black
                // ),
                ),
                Container(
                  height: 200.0,
                  color: Colors.grey[200],
                )


              ],),
        
      ),
          ),
    );
  }
}