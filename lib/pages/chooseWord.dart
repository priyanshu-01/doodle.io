import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'dart:math';
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
              return   Center(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue[50]
                ),
          
          height: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('choose a word'),
              Container(
                height: 200.0,
                //color: Colors.red,
                child:Column(children: <Widget>[
                  FlatButton(child: Text(displayWords[0]),
              onPressed: (){
                choosenWord= displayWords[0];
                updateWord();
                wc=false;
              },
              ),
              FlatButton(child: Text(displayWords[1]),
              onPressed: (){
                choosenWord= displayWords[1];
                updateWord();
                wc=false;
              },
              ),
              FlatButton(child: Text(displayWords[2]),
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
      )
      
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
  await Firestore.instance.collection('rooms').document(documentid).updateData({'word':choosenWord});
}