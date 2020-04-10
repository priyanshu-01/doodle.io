import 'package:flutter/material.dart';
import 'package:scribbl/pages/gameScreen.dart';
import 'package:scribbl/pages/timer.dart';
import 'painter.dart';
import 'gameScreen.dart';
import 'room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chooseWord.dart';
import 'package:google_fonts/google_fonts.dart';
String choosenWord;
class PainterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
                      child: Container(
              //constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                Painter(),
                Container(
                  child: Column(children: <Widget>[
                    Container(
                      height: 50.0,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Time(),
                        Text('$word'),   
                        
                  // Text('67'),
                      ],),
                    ),
                      Container(
                     // constraints: BoxConstraints.expand(),
                      height: 200.0,
                     // width: 150.0,
                      color: Colors.grey[100],
                       child : Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ListView.builder(
                               //shrinkWrap: true,
                               reverse: true,                  
                               itemCount: chat.length,
                               itemBuilder: (BuildContext context, int index) {
                                     //print('got new message');
                                     String both = chat[chat.length-1-index];
                                     String n = both.substring(0, both.indexOf(']') );
                                     String m = both.substring( both.indexOf(']')+1 );

                                      if(m==' doodle123 '){
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text('$n Guessed', style: TextStyle(color: Colors.green,
                                          fontSize: 14.0
                                          
                                          ),),
                                        );

                                      }

                                    else return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('$n', style: GoogleFonts.roboto(color: Colors.red[800])),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                         child: Container(
                                        
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('$m', style: TextStyle(fontSize: 12.0)),
                                        )),
                                    )
                                     ],);
                          },
                         ),
                       ),

                     ),
                  ],),
                )


              ],),
        
      ),
          ),
    );
  }
}