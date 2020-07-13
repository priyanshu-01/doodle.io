import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
import 'package:scribbl/pages/room/room.dart';
import '../Select_room/selectRoom.dart';
import 'guesserScreen.dart';

class ChatBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (keyboardState)
        ? Container()
        : FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: textAndChat),
                  color: textAndChat
                  //  color: Color(0xFFFFF1E9)
                  //color: Color(0xFFFABBB9),
                  // color: Colors.blueAccent[100]
                  ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatList(),
              ),
            ),
          );
  }
}

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ChatData>(context);
    int lastIndex = roomData['$identity Chat'];
    if (lastIndex != null &&
        chat[lastIndex].substring(0, chat[lastIndex].indexOf('[')) !=
            identity) {
      chat = chat + [newMessage];
      sendMessage();
    }
    return ListView.builder(
      reverse: true,
      itemCount: chat.length,
      itemBuilder: (BuildContext context, int index) {
        String both = chat[chat.length - 1 - index];
        String i = both.substring(0, both.indexOf('['));
        String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
        String m = both.substring(both.indexOf(']') + 1);
        return Container(
          child: Column(
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF504A4B),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xFF504A4B),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 5.0, 6.0, 5.0),
                              child: Column(
                                children: [
                                  Text('$m',
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 14.0,
                            child: CircleAvatar(
                              radius: 13.0,
                              backgroundColor: Colors.grey[100],
                              backgroundImage: NetworkImage(playersImage[
                                  playersId.indexOf(i)]), //error by crashlytics
                            ),
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
                                  backgroundColor: Colors.black,
                                  radius: 14.0,
                                  child: CircleAvatar(
                                    radius: 13.0,
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: NetworkImage(
                                        playersImage[playersId.indexOf(i)]),
                                  ),
                                ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameOfOthers(iden: i, nam: n),
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
          ),
        );
      },
    );
  }
}

class NameOfOthers extends StatelessWidget {
  final String iden, nam;
  NameOfOthers({this.iden, this.nam});
  @override
  Widget build(BuildContext context) {
    if (iden == identity.toString())
      return Container(
        height: 0,
        width: 0,
      );
    else
      return Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Text('$nam',
            style: GoogleFonts.ubuntu(
                //   color: Color(0xFFA74AC7),
                color: Color(0xFFFF4893),
                fontSize: 10.0,
                fontWeight: FontWeight.bold)),
      );
  }
}
