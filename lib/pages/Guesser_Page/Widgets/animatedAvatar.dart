import 'package:flutter/material.dart';
import 'package:scribbl/pages/room/room.dart';
import '../../selectRoom.dart';
import '../guesserScreen.dart';
class AnimatedAvatar extends StatefulWidget {
  @override
  _AnimatedAvatarState createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with TickerProviderStateMixin {
  AnimationController controlAvatar;
  RelativeRectTween relativeRectTween;
  @override
  initState() {
    controlAvatar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    double photoSize = 120.0;
    double leftPadding = ((totalWidth / 2) - 50) - photoSize / 2;
    double topPadding = ((guessCanvasLength / 2) / 2) - (photoSize / 2);

    double denIconSize = 50.0;
    double rightIconPadding = 5.0;
    double topIconPadding = 5.0;

    relativeRectTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          leftPadding,
          topPadding,
          totalWidth - 50 - leftPadding - photoSize,
          (guessCanvasLength / 2) - topPadding - photoSize),
      end: RelativeRect.fromLTRB(
          totalWidth - 50 - rightIconPadding - denIconSize,
          topIconPadding,
          rightIconPadding,
          (guessCanvasLength / 2) - topIconPadding - denIconSize),
    );
    super.initState();
  }

  void animateAvatarFunc(BuildContext context) {
    if (avatarAnimation == animateAvatar.reset) {
      print('reset');
      avatarAnimation = animateAvatar.done;
      controlAvatar.value = 0.0;
    } else if (avatarAnimation == animateAvatar.start) {
      print('start');
      avatarAnimation = animateAvatar.done;
      controlAvatar.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateAvatarFunc(context);
    }); //called each time build gets completed

    return Container(
      width: totalWidth - 50,
      height: guessCanvasLength / 2,
      child: Stack(
        children: <Widget>[
          PositionedTransition(
            rect: relativeRectTween.animate(controlAvatar),
            child: Container(
              child: ClipOval(
                child: Image.network(
                  playersImage[playersId.indexOf(denId)],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controlAvatar.dispose();
    super.dispose();
  }
}

