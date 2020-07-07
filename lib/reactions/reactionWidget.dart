import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';

class ReactionWidget extends StatefulWidget {
  final Image reaction;
  final Image sender;
  final Function() hide;

  ReactionWidget({this.reaction, this.sender, this.hide});
  @override
  _ReactionWidgetState createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget>
    with TickerProviderStateMixin {
  AnimationController controllerPhoto;
  CurvedAnimation curvedAnimationPhoto;

  AnimationController controllerReaction;
  CurvedAnimation curvedAnimationReaction;

  AnimationController waitReaction;

  RelativeRectTween relativeRectTween;

  Widget reactionContent = Container();

  @override
  void initState() {
    controllerPhoto = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
        lowerBound: 0.0,
        upperBound: 1.0)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            reactionContent = widget.reaction;
          });
          controllerReaction.forward(from: 0.0);
        } else if (status == AnimationStatus.dismissed) {
          widget.hide();
        }
      });

    curvedAnimationPhoto =
        CurvedAnimation(parent: controllerPhoto, curve: Curves.easeOutExpo);

    controllerReaction = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
        lowerBound: 0.0,
        upperBound: 1.0)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          waitReaction.forward();
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            reactionContent = Container();
          });
          controllerPhoto.reverse(from: 1.0);
        }
      });

    curvedAnimationReaction =
        CurvedAnimation(parent: controllerReaction, curve: Curves.easeOutExpo);

    waitReaction =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed)
              controllerReaction.reverse(from: 1.0);
          });

    relativeRectTween = RelativeRectTween(
      begin: RelativeRect.fromLTRB(totalWidth * 0.1, 0.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, 0.0, totalWidth * 0.1, 0.0),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerPhoto.forward(from: 0.0);
    });
    super.initState();
  }

  @override
  void dispose() {
    controllerPhoto.dispose();
    controllerReaction.dispose();
    waitReaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: totalWidth * 0.3,
        child: Stack(
          children: [
            PositionedTransition(
              rect: relativeRectTween.animate(curvedAnimationReaction),
              child: reactionContent,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ScaleTransition(
                scale: curvedAnimationPhoto,
                child: ClipOval(
                  child: widget.sender,
                ),
              ),
            ),
          ],
        ));
  }
}
