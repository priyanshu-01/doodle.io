import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/room/room.dart';
import '../selectRoom.dart';
import 'guesserScreen.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int lastIndex = roomData['$identity Chat'];
  if (lastIndex != null &&
      chat[lastIndex].substring(0, chat[lastIndex].indexOf('[')) != identity) {
    chat = chat + [newMessage];
    sendMessage();
  }
    return ListView.builder(
    reverse: true,
    itemCount: chat.length,
    itemBuilder: (BuildContext context, int index) {
      //print('error below');
      String both = chat[chat.length - 1 - index];
      String i = both.substring(0, both.indexOf('['));
      String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
      String m = both.substring(both.indexOf(']') + 1);
      return Column(
        crossAxisAlignment: (identity.toString() == i)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          (i == identity.toString())
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Bubble(
                          nip: BubbleNip.rightTop,
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                            child: Column(
                              children: [
                                nameOfOthers(i, n),
                                Text('$m',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )),
                      CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.grey[100],
                        backgroundImage:
                            NetworkImage(playersImage[playersId.indexOf(i)]), //error by crashlytics
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      (playersId.indexOf(i) == -1)
                          ? Container()
                          : CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.grey[100],
                              backgroundImage: NetworkImage(
                                  playersImage[playersId.indexOf(i)]),
                            ),
                      Bubble(
                        nip: BubbleNip.leftTop,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 2.0,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              nameOfOthers(i, n),
                              Text('$m',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      );
    },
  );
  }
}