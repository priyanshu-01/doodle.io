import 'package:flutter/material.dart';
import '../pages/selectRoom.dart';
import '../pages/Guesser_Page/guesserScreen.dart';
import '../pages/room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
bool switcher= false;  
RelativeRectTween relativeRectTween;

AnimationController controllerGiftSize;
CurvedAnimation curvedAnimationGiftSize;

@override
void initState() { 
    controlGift = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,

    )..addStatusListener((status) {
          if(status==AnimationStatus.completed)
          controllerGiftSize.forward();
          if(status==AnimationStatus.dismissed)
          controllerGiftSize.reset();
     });

   
    controllerGiftSize=AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    curvedAnimationGiftSize= CurvedAnimation(parent: controllerGiftSize,curve: Curves.easeInOutBack);

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
  super.initState();
}

@override
  void dispose() {
    controllerGiftSize.dispose();
    super.dispose();
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
          GridView.builder(
            itemCount: reactions.length,
             scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
            itemBuilder: (BuildContext context, int index){
              return   InkWell(
                onTap: (){
                  switcher=!switcher;
                  addReaction(index);
                  controlGift.reverse();
                },
                
                   child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ScaleTransition(
                    scale: curvedAnimationGiftSize,
                                      child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[200]),
                        borderRadius: BorderRadius.circular(40.0),
                                            color: Colors.grey[100],

                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image(image: AssetImage(reactions[index])),
                        ),
                      ),
                  ),
                ),
              );
            })


          ),
        ),]
      ),
    );
  }
  
   Future<void> addReaction(int index) async{
     await Firestore.instance
     .collection('rooms')
     .document(documentid)
     .updateData({
       '$identity reaction': '$index $switcher'
     });
   }
   
}
