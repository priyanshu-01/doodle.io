import 'package:flutter/material.dart';
import '../pages/selectRoom.dart';
import '../pages/guesserScreen.dart';
List reactions = [
  'assets/reactions/thumbUp.png',
  'assets/reactions/thumbDown.png',
  'assets/reactions/middleFinger.png',
  'assets/reactions/fire.png'
  ];

class AnimatedGift extends StatefulWidget {
  @override
  _AnimatedGiftState createState() => _AnimatedGiftState();
}

class _AnimatedGiftState extends State<AnimatedGift> with TickerProviderStateMixin {
RelativeRectTween relativeRectTween;
@override
void initState() { 
    controlGift = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,

    );
    relativeRectTween= RelativeRectTween(
         begin: RelativeRect.fromLTRB(
           0.0,
           0.0,
           totalWidth,
           totalLength*0.4,
           
         ),
         end: RelativeRect.fromLTRB(
           0.0,
          0.0,
           0.0,
           10.0,
         )

    );
    // controlGift.addListener(() { });
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return (keyboardState)?Container():
     Container(
      // constraints: BoxConstraints.expand(),
      //color: Colors.red,
      child: Stack(
        children: <Widget>[
             PositionedTransition(
          rect: relativeRectTween.animate(controlGift),
          child: Container(
            decoration: BoxDecoration(
                          color: Colors.white,
             border: Border.all(color: Colors.white),
             borderRadius: BorderRadius.circular(15.0)
            ),
            constraints: BoxConstraints.expand(),
            width: totalWidth-20,
           child: 
          //  SvgPicture.asset('assets/reactions/fire2.svg',
          //  semanticsLabel: 'fire',
          //  ),
          GridView.builder(
            itemCount: reactions.length,
             scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
            itemBuilder: (BuildContext context, int index){
              return   Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey[200]),
                    borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.grey[100],

                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image(image: AssetImage(reactions[index])),
                    ),
                  ),
              );
            })


          ),
        ),]
      ),
    );
  }
}