import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'gameScreen.dart';
import 'dart:math';
  var displayWords = [' ',' ',' '];
class ChooseWordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_,a){
                  return  FlatButton(child: Text(displayWords[a]),
              onPressed: (){
                choosenWord= displayWords[a];
                updateWord();
              },
              );
                })
              )
            ],
          ),
        ),
      )
      
    );
         
    // 
  }


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
  await  Firestore.instance.collection('rooms').document(documentid).updateData({'wordChosen':true});
}

Future<void> updateWord() async{
  await Firestore.instance.collection('rooms').document(documentid).updateData({'word':choosenWord});
}