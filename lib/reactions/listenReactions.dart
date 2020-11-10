import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/gift/menu.dart';
import '../pages/room/room.dart';
import 'reaction_view.dart';
import '../pages/Select_room/selectRoom.dart';

class ReactionListener {
  Map reactionRecord;

  List vacantSpaces;
  Map spaces;

  ReactionListener() {
    reactionRecord = {};
    spaces = {0: false, 1: false, 2: false, 3: false};
    vacantSpaces = [
      totalLength * 0.16,
      totalLength * 0.24,
      totalLength * 0.32,
      totalLength * 0.40
    ];
  }

  void listenReactions(BuildContext context) {
    // if (reactionRecord.length != playersId.length
    //     // && game == false
    //     ) initialiseRecord();

    roomData['userData'].forEach((key, value) {
      if (reactionRecord.containsKey(key) &&
          value['lastReaction'] != null &&
          value['lastReaction'] != reactionRecord[key]) {
        Timer(Duration(milliseconds: 350), () async {
          audioPlayer.playSound('reaction');
        });
        // String keyStr = key.toString();
        // String id = keyStr.substring(0, keyStr.indexOf(' '));
        String id = key.toString();
        int index = extractIndex(value['lastReaction']);

        showReaction(context, reactionImage(index), senderImage(id));

        reactionRecord[key] = value['lastReaction'];
      }
    });
  }

  void updateReactionRecord() {
    roomData['userData'].forEach((key, value) {
      if (!reactionRecord.containsKey(key))
        reactionRecord.update(
          '$key',
          (value) => roomData['userData']['$key']['lastReaction'],
          ifAbsent: () => roomData['userData']['$key']['lastReaction'],
        );
    });
  }

  int extractIndex(String val) {
    int index = int.parse(val.substring(0, val.indexOf(' ')));
    return index;
  }

  Image senderImage(String id) {
    return Image(
      image: CachedNetworkImageProvider(
          playersImage[playersId.indexOf(id)] //catch this
          ),
    );
  }

  Image reactionImage(int index) {
    return reactionsMenu[index]['image'];
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
