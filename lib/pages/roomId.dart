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
          RaisedButton(
            onPressed: () {
              flag = false;
              (enteredId != null) ? val = int.parse(enteredId) : val = 0;
              getDetails(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: (status == 'Join')
                  ? Text(
                      'Join',
                      style: GoogleFonts.quicksand(
                          color: Colors.white, fontSize: 35.0),
                    )
                  : SpinKitFadingCircle(color: Colors.white),
            ),
            color: Colors.red[800],
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
      Navigator.push(context, createRoute(val, widget.currency));
    } else {
      setState(() {
        status = 'Join';
        mistake = true;
      });
    }
  }
}
