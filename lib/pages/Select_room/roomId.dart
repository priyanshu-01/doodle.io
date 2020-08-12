import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import '../room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
import '../../ProviderManager/manager.dart';

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
  bool processingJoinRoom = false;
  int val;
  // String status;
  @override
  void initState() {
    processingJoinRoom = false;
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
          BeautyTextfield(
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
          showWarning(),
          InkWell(
            enableFeedback: false,
            onTap: () => (!processingJoinRoom)
                ? {
                    flag = false,
                    (enteredId != "" &&
                            enteredId != null &&
                            (!enteredId.contains(' ')))
                        ? val = int.parse(enteredId)
                        : val = 0,
                    getDetails(context)
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: color['buttonBg'],
              ),
              child: (!processingJoinRoom)
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
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
                      ))
                  : Container(
                      height: 70.0,
                      width: 100.0,
                      child: SpinKitFadingCircle(color: Colors.white)),
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
        style: GoogleFonts.quicksand(color: Colors.white),
      );
    }
  }

  Future<void> getDetails(BuildContext context) async {
    audioPlayer.playSound('click');

    setState(() {
      if (mistake == true) mistake = false;
      processingJoinRoom = true;
    });
    // QuerySnapshot qs;
    var ref = Firestore.instance;
    await ref
        .collection("rooms")
        .where('id', isEqualTo: val)
        .getDocuments()
        .then((value) {
      if (value.documents.length != 0) {
        processingJoinRoom = false;
        documentid = value.documents[0].documentID;
        roomData = value.documents[0].data;
        readRoomData();
        if (playersId.indexOf(identity) == -1) {
          addPlayer().whenComplete(() {
            Navigator.pop(context);
            Navigator.push(context, createRoute(val, widget.currency));
          });
        } else {
          Navigator.pop(context);
          Navigator.push(context, createRoute(val, widget.currency));
        }
      } else {
        setState(() {
          processingJoinRoom = false;
          mistake = true;
        });
      }
    });
  }
}
