import 'package:achievement_view/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/room/room.dart';
import '../../selectRoom.dart';
import '../guesserScreen.dart';
class TextBox extends StatefulWidget {
  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final FocusNode fn = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 10.0),
              child: InkWell(
                child: Image(
                  image: AssetImage('assets/icons/gift.gif'),
                ),
                onTap: () {
                  if (fn.hasFocus) {
                    fn.unfocus();
                    controlGift.forward(from: 0.0);
                  } else {
                    (controlGift.value == 0.0)
                        ? controlGift.forward(from: 0.0)
                        : controlGift.reverse();
                  }
                },
              )),
          Container(
            width: totalWidth * 0.7,
            color: Colors.white,
            height: 50.0,
            child: TextField(
              style: GoogleFonts.ubuntu(
                fontSize: 20.0,
                //fontWeight: FontWeight.bold
              ),
              focusNode: fn,
              cursorColor: Color(0xFF1A2F77),
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFFF4893),
                  )),
                  hintText: 'Type Here',
                  focusColor: Colors.white),
              controller: messageHolder,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.newline,
              onChanged: (mess) {
                setState(() {
                  message = mess;
                });
              },
              onEditingComplete: () {},
              onSubmitted: (String a) => onSend(),
            ),
          ),
          (message == '')
              ? (keyboardState)
                  ? IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30.0,
                        color: Color(0xFFFF4893),
                      ),
                      onPressed: () {
                        fn.unfocus();
                        // FocusScope.of(context).unfocus();
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        size: 30.0,
                        color: Color(0xFFFF4893),
                      ),
                      onPressed: () {
                        fn.requestFocus();
                      },
                    )
              : IconButton(
                  icon: Icon(
                    Icons.send,
                    //color: Color(0xFF16162E),
                    color: Color(0xFFFF4893),
                    //  color: Color(0xFF1A2F77),
                    //   color: Color(0xFFA74AC7),
                    size: 30.0,
                  ),
                  //onPressed:=>onSend(),
                  onPressed: () => onSend(),
                ),
        ],
      ),
    );
  }

  void onSend() {
    message = ' $message ';
    if (message != '  ') {
      messageHolder.clear();
      // messageHolder.clearComposing();
      String lowerCase = message.toLowerCase();
      if (lowerCase.indexOf(word) != -1) {
        message = 'd123';
        if (guessersId.indexOf(identity) == -1) {
          if (guessersId.length < counter - 2) showPopup(context);
          calculateScore();
          updateGuesserId();
        }
      } else {
        newMessage = '$identity[$userNam]$message';
        chat.add(newMessage);
        sendMessage();
      }
    }
    message = '';
    fn.unfocus();
  }

  void showPopup(context) {
    AchievementView(context,
        title: "Bingo!",
        subTitle: '',
        isCircle: true,
        icon: Icon(Icons.done),
        textStyleTitle: TextStyle(color: Colors.white, fontSize: 17.0),
        alignment: Alignment.topCenter,
        duration: Duration(seconds: 1),
        color: Colors.green[700])
      ..show();
  }

  Future<void> updateGuesserId() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({
      '$identity': '$denId $round',
    });
  }

  void calculateScore() {
    //1 time
    int s1;
    int currentTime = 500000000; //currentG - 5;           //NEEDS TO BE CHANGED
    s1 = (currentTime ~/ 10) + 1;
    s1 = s1 * 10;
    int s2;
    double per = (guessersId.length / roomData['counter']) * 100;
    s2 = per.round();
    s2 = 100 - s2;
    score = s1 + s2;
    score = score ~/ 2;
    //2 percentage of people who have already guessed

    //claculate score for denner
  }
}




Future<void> sendMessage() async {
  await Firestore.instance
      .collection('rooms')
      .document(documentid)
      .updateData({'chat': chat, '$identity Chat': chat.length - 1});
}
