import 'package:flutter/material.dart';
import 'package:scribbl/pages/chooseWord.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'room.dart';
import 'painterView.dart';
import 'guesserView.dart';
import 'WaitScreen.dart';
//List player = new List();
class GameScreen extends StatefulWidget {
  @override
  // void initState(){}
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState(){
    //startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //startTimer();
    //iterate();
      
      //player = snapshot.data.documents[0]['users'];
      if(denner==userNam)
      {
          if(word!=' ')
            {
              //startTimer();
              return PainterView();
            }
          
          else
          return ChooseWordDialog();
      }
      
      else
      {
        if(word!=' ')
        return GuesserView();
        else
        return WaitScreen();
      }
    
    
  }
}

// void iterate(){

// }

