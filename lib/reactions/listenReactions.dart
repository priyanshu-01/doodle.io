import 'package:flutter/material.dart';
import 'package:scribbl/gift/menu.dart';
import '../pages/room/room.dart';
import 'reaction_view.dart';
import '../pages/selectRoom.dart';
import '../gift/gift_contents.dart';

class ReactionListener {
  Map reactionRecord = {};

  List vacantSpaces;
  Map spaces;

  ReactionListener() {
    spaces = {0: false, 1: false, 2: false, 3: false};
    vacantSpaces = [
      totalLength * 0.16,
      totalLength * 0.24,
      totalLength * 0.32,
      totalLength * 0.40
    ];
  }

  void listenReactions(BuildContext context) {
    if (reactionRecord.length != playersId.length && game == false)
      initialiseRecord();

    roomData.forEach((key, value) {
      if (reactionRecord.containsKey(key) && value != reactionRecord[key]) {
        String keyStr = key.toString();
        String id = keyStr.substring(0, keyStr.indexOf(' '));

        int index = extractIndex(value);

        showReaction(context, reactionImage(index), senderImage(id));

        reactionRecord[key] = value;
      }
    });
  }

  void initialiseRecord() {
    playersId.forEach((element) {
      reactionRecord.update(
        '$element reaction',
        (value) => '',
        ifAbsent: () => null,
      );
    });
  }

  int extractIndex(String val) {
    int index = int.parse(val.substring(0, val.indexOf(' ')));
    return index;
  }

  Image senderImage(String id) {
    return Image(
      image: NetworkImage(playersImage[playersId.indexOf(id)] //catch this
          ),
    );
  }

  Image reactionImage(int index) {
    return Image(
      image: AssetImage(reactionsMenu[index]['path']),
    );
  }

  void showReaction(BuildContext context, Image reaction, Image sender) {
    ReactionView(
      context,
      sender: sender,
      reaction: reaction,
    )..show(judgePositon());
  }

  int judgePositon() {
    int i;
    for (i = 0; i < 4; i++) {
      if (!spaces[i]) {
        spaces[i] = true;
        break;
      }
    }
    if (i == 4) i = 0;
    return i;
  }
}
