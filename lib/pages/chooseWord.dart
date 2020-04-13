import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'room.dart';
import 'dart:math';
import 'painterScreen.dart';
import 'painterScreen.dart';
  var displayWords = [' ',' ',' '];
bool  wc= false;
class ChooseWordDialog extends StatefulWidget {
  @override
  _ChooseWordDialogState createState() => _ChooseWordDialogState(); 
}
class _ChooseWordDialogState extends State<ChooseWordDialog> {
  @override
  Widget build(BuildContext context) {
    if(wc==false)
    getWords();
              return   Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.orange[600]
                  ),
                    height: 300.0,
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      child: Column(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                Text('Choose a word',style: GoogleFonts.quicksand(color: Colors.white, fontSize: 25.0), ),
                Container(
                  height: 200.0,
                  //color: Colors.red,
                  child:Column(children: <Widget>[
                      FlatButton(
                        color: Colors.white,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        child: Text(displayWords[0]),
                onPressed: (){
                  //PainterScreen().startTimer();
                  choosenWord= displayWords[0];
                  updateWord();
                  wc=false;
                },
                ),
                FlatButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Text(displayWords[1]),
                onPressed: (){
                  choosenWord= displayWords[1];
                  updateWord();
                  wc=false;
                },
                ),
                FlatButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  
                  child: Text(displayWords[2]),
                onPressed: (){
                  choosenWord= displayWords[2];
                  updateWord();
                  wc=false;
                },
                ),
                  ],)
                )
                        ],
                      ),
                    ),
                  ),
              );
         
    // 
  }
  Future<void> getWords() async{
  
  var words;
  int length;
  words= await Firestore.instance.collection('words').document('word list').get();
  List word = words['list'];
  length= word.length;
Random random = Random();
double randomNumber;
int index;
//displayWords=[];
  for (int i=0;i<3;i++){
  randomNumber = random.nextDouble() * (length-1);
  index = randomNumber.toInt();
   displayWords[i]=(word[index]);
  }
  setState(() {
    wc=true;
  });
  //await  Firestore.instance.collection('rooms').document(documentid).updateData({'wordChosen':true});
}
}



Future<void> updateWord() async{
  await Firestore.instance.collection('rooms').document(documentid).updateData({'word':choosenWord,'wordChosen':true});
}