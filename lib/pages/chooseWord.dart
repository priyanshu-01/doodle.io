import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'room.dart';
import 'dart:math';
import 'painterScreen.dart';
import 'guesserScreen.dart';
  var displayWords = [' ',' ',' '];
bool  wc= false;
Color wordBack;
Color wordText;
class ChooseWordDialog extends StatefulWidget {
  @override
  _ChooseWordDialogState createState() => _ChooseWordDialogState(); 
}
class _ChooseWordDialogState extends State<ChooseWordDialog> {
  @override
  Widget build(BuildContext context) {
    //wordBack= Color(0xFFFFE5B4);
    wordBack=null;
   // wordText=Color(0xFF1A2F77);
   wordText=Colors.black;
    if(wc==false)
    getWords();
              return   Container(
                decoration: BoxDecoration(
                  
                  image: DecorationImage(
                    fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    image: AssetImage('assets/images/pencil.jpg')
                  )
                ),
                // color: Colors.white,
                constraints: BoxConstraints.expand(),
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
              Text('Pick a word',style: GoogleFonts.notoSans(color: Colors.black, fontSize: 25.0), ),
              Container(
                height: 200.0,
                //color: Colors.red,
                child:Column(children: <Widget>[
                FlatButton(
                  color: wordBack,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  child: Text(displayWords[0].toUpperCase(), style: GoogleFonts.poppins(color: wordText ,  fontSize: 18.0),),
              onPressed: (){
                //PainterScreen().startTimer();
                choosenWord= displayWords[0];
                updateWord();
                wc=false;
              },
              ),
              FlatButton(
                color:wordBack,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                child: Text(displayWords[1].toUpperCase(), style: GoogleFonts.poppins(color: wordText ,  fontSize: 18.0),),
              onPressed: (){
                choosenWord= displayWords[1];
                updateWord();
                wc=false;
              },
              ),
              FlatButton(
                color: wordBack,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                
                child: Text(displayWords[2].toUpperCase(), style: GoogleFonts.poppins(color: wordText ,  fontSize: 18.0),),
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