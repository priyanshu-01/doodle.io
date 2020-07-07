import 'package:flutter/material.dart';
import 'reactionWidget.dart';
import '../pages/Select_room/selectRoom.dart';

class ReactionView {
  int placeHolder;
  BuildContext context;
  Image reaction;
  Image sender;
  double top;
  OverlayEntry overlayEntry;
  ReactionView(
    this.context, {
    this.reaction,
    this.sender,
  });

  OverlayEntry buildOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Stack(children: <Widget>[
          Positioned(
            height: totalLength * 0.065,
            right: 10.0,
            top: top,
            child: ReactionWidget(
              reaction: reaction,
              sender: sender,
              hide: hide,
            ),
          ),
        ]);
      },
    );
  }

  void show(int i) {
    placeHolder = i;
    top = reactionListener.vacantSpaces[i];

    if (overlayEntry == null) {
      overlayEntry = buildOverlay();
      Overlay.of(context).insert(overlayEntry);
    }
  }

  void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
    reactionListener.spaces[placeHolder] = false;
  }
}
