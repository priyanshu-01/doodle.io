import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/room/room.dart';

import 'guesserScreen.dart';

class PopUpChat extends StatefulWidget {
  @override
  _PopUpChatState createState() => _PopUpChatState();
}

class _PopUpChatState extends State<PopUpChat> {
  @override
  void initState() {
    popUpAdder = chat.length;
    popUpRemover = chat.length;
    // popUpStack = [];
    // buildGotCompleted = chat.length;
    super.initState();
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  Widget buildRemovedItem(
      BuildContext context, int a, Animation<double> animation) {
    return _buildToBeRemovedItem(context, a, animation);
  }

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

    while (popUpAdder < chat.length) {
      if (_listKey.currentState != null)
        _listKey.currentState.insertItem(0,
            duration: const Duration(milliseconds: 150)); //might give error

      popUpAdder++;
      // popUpStack =
      //     (popUpRemover < chat.length) ? chat.sublist(popUpRemover) : [];
      Timer(
          Duration(
            seconds: 3,
          ), () {
        popUpRemover++;
        if (_listKey.currentState != null)
          _listKey.currentState.removeItem(
            popUpAdder - popUpRemover,
            (BuildContext context, Animation<double> animation) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // popUpStack = (popUpRemover < chat.length)
                //     ? chat.sublist(popUpRemover)
                //     : [];
                // buildGotCompleted++;
              });
              return buildRemovedItem(context, popUpRemover - 1, animation);
            },
            duration: const Duration(milliseconds: 200),
          );
      });
    }

    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      // color: Colors.green,
      height: totalLength * 0.3,
      width: totalWidth * 0.45,
      child: AnimatedList(
          key: _listKey,
          physics: NeverScrollableScrollPhysics(),
          reverse: true,
          initialItemCount: 0,
          itemBuilder: (BuildContext context, int index, animation) =>
              _buildItem(context, index, animation)),
    );
  }

  _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    String both = chat[chat.length - 1 - index]; //Doubt here
    String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
    String m = both.substring(both.indexOf(']') + 1);
    return Row(
      children: [
        Container(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
            child: FadeTransition(
              opacity: animation,
              child: Container(
                width: totalWidth * 0.45 - 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            textScaleFactor: 0.9,
                            maxLines: 4,
                            text: (m != 'd123')
                                ? new TextSpan(
                                    text: '$n :',
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: m,
                                        style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                : TextSpan(
                                    text: '$n guessed',
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildToBeRemovedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    String both = chat[index];
    String n = both.substring(both.indexOf('[') + 1, both.indexOf(']'));
    String m = both.substring(both.indexOf(']') + 1);
    return Row(
      children: [
        Container(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
            child: FadeTransition(
              opacity: animation,
              child: Container(
                width: totalWidth * 0.45 - 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: RichText(
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            textScaleFactor: 0.9,
                            maxLines: 4,
                            text: (m != 'd123')
                                ? new TextSpan(
                                    text: '$n :',
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: m,
                                        style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                : TextSpan(
                                    text: '$n guessed',
                                    style: GoogleFonts.ubuntu(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
