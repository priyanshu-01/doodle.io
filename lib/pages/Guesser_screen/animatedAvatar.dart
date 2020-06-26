import 'package:flutter/material.dart';

import 'guesserScreen.dart';
import '../selectRoom.dart';
import '../room/room.dart';
class AnimatedAvatar extends StatefulWidget {
  @override
  _AnimatedAvatarState createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with TickerProviderStateMixin {

      AnimationController controlAvatar;
      CurvedAnimation curvedAnimationAvatar;


      AnimationController scaleAvatar;
      CurvedAnimation curvedScaleAvatar;

  RelativeRectTween relativeRectTween;
  @override
  initState() {
    controlAvatar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    curvedAnimationAvatar =
        CurvedAnimation(parent: controlAvatar, curve: Curves.easeInBack);


     scaleAvatar= AnimationController(
       vsync: this,
       duration: Duration(milliseconds: 1000)
     ); 
     curvedScaleAvatar = CurvedAnimation(parent: scaleAvatar, curve: Curves.bounceOut);



    double photoSize = 120.0;
    double leftPadding = ((totalWidth / 2) - 50) - photoSize / 2;
    double topPadding = ((guessCanvasLength / 2) / 2) - (photoSize / 2);

    double denIconSize = 50.0;
    double rightIconPadding = 5.0;
    double topIconPadding = guessCanvasLength;

    relativeRectTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          leftPadding,
          topPadding,
          totalWidth - 50 - leftPadding - photoSize,
          (guessCanvasLength ) - topPadding - photoSize),
      end: RelativeRect.fromLTRB(
          //totalWidth - 50 - rightIconPadding - denIconSize,
          leftPadding+(photoSize/2),
          topIconPadding,
          //rightIconPadding,
          totalWidth/2,
          //(guessCanvasLength / 2) - topIconPadding - denIconSize
          0.0,
          ),
    );


    super.initState();
  }
  void animateAvatarFunc(BuildContext context) {
    if (avatarAnimation == animateAvatar.reset) {
      print('reset');
      avatarAnimation = animateAvatar.done;
      controlAvatar.value = 0.0;
      scaleAvatar.reset();
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
      scaleAvatar.forward();
    }); //called each time build gets completed

    return Container(
      width: totalWidth - 50,
      height: guessCanvasLength ,
      child: Stack(
        children: <Widget>[
          PositionedTransition(
            rect: relativeRectTween.animate(curvedAnimationAvatar),
            child: Container(
              child: ScaleTransition(
                scale: curvedScaleAvatar,
                              child: ClipOval(
                  child:(playersId.indexOf(denId)!=-1)?
                   Image.network(
                    playersImage[playersId.indexOf(denId)],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ):
                  CircleAvatar(backgroundColor: Colors.brown,),
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
    scaleAvatar.dispose();
    super.dispose();
  }
}
