import 'package:flutter/material.dart';
import 'package:scribbl/pages/guesser.dart';
import 'package:scribbl/pages/wordWas.dart';
import 'painterScreen.dart';
import 'guesserScreen.dart';
import 'room.dart';
import 'selectRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'result.dart';
List displayNames;
List displayScores;
String docId;
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // return WordWas();
      if(round<=numberOfRounds){
        if(denId==identity)
          {
           denCanvasLength = MediaQuery.of(context).size.height*0.5;
           updateDimension(); 
            return PainterScreen();
          }
              
      else
        return GuesserScreen();
      }
      else{
        docId= documentid;
        displayNames= players;
        displayScores= finalScore;
        // Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Result()) );
        // if(identity==hostId)
        // delDoc();
        print('still in gameScreen');
        return Result();
      }
      // return GuesserScreen();
  }
}
Future<void> delDoc() async{
     await Firestore.instance.collection('rooms').document(docId).delete().catchError((e){
           print(e);
           print('its an error');
         });
}
Future<void> updateDimension() async{
            if(a['denCanvasLength']!=denCanvasLength)
                      Firestore.instance
                      .collection('rooms')
                        .document(documentid)
              .updateData({
                'denCanvasLength':denCanvasLength
              });
}


