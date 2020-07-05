import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_textfield/beauty_textfield.dart';

bool mistake = false;
String enteredId;
var details;

class EnterRoomId extends StatefulWidget {
  final Currency currency;
  EnterRoomId({this.currency});
  @override
  _EnterRoomIdState createState() => _EnterRoomIdState();
}

class _EnterRoomIdState extends State<EnterRoomId> {
  int val;
  String status;
  @override
  void initState() {
    status = 'Join';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: totalLength * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: BeautyTextfield(
              width: totalWidth * 0.7,
              prefixIcon: Icon(
                Icons.vpn_key,
                color: Colors.white,
              ),
              height: 60.0,
              inputType: TextInputType.number,
              placeholder: 'Room ID',
              margin: EdgeInsets.all(10.0),
              accentColor: Colors.black,
              textColor: Colors.white,
              enabled: true,
              autofocus: true,
              onChanged: (str) {
                enteredId = str;
                setState(() {
                  mistake = false;
                });
              },
            ),
          ),
          showWarning(),
          InkWell(
            enableFeedback: false,
            onTap: () {
              flag = false;
              (enteredId != null) ? val = int.parse(enteredId) : val = 0;
              getDetails(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: color['buttonBg'],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: (status == 'Join')
                    ? Text(
                        'JOIN',
                        style: GoogleFonts.fredokaOne(
                            letterSpacing: 1.4,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1.0, -1.0),
                                  color: Colors.black),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.0, -1.0),
                                  color: Colors.black),
                              Shadow(
                                  // topRight
                                  offset: Offset(2.5, 2.5),
                                  color: Colors.black),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.0, 1.0),
                                  color: Colors.black),
                            ],
                            //color: Colors.orange[700],
                            color: color['bg2'],
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800),
                      )
                    : SpinKitFadingCircle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showWarning() {
    if (mistake == false) {
      return Container();
    } else {
      return Text(
        'It seems you made a mistake, Try Again!',
        style: GoogleFonts.quicksand(color: Colors.black),
      );
    }
  }

  Future<void> getDetails(BuildContext context) async {
    await audioPlayer.playSound('click');

    setState(() {
      if (mistake == true) mistake = false;
      status = 'Joining..';
    });
    QuerySnapshot qs;
    var ref = Firestore.instance;
    qs = await ref
        .collection("rooms")
        .where('id', isEqualTo: val)
        .getDocuments();

    if (qs.documents.length != 0) {
      status = 'Join';
      Navigator.pop(context);
      Navigator.push(context, createRoute(val, widget.currency));
    } else {
      setState(() {
        status = 'Join';
        mistake = true;
      });
    }
  }
}
