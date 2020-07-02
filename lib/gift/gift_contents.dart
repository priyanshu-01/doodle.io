import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/gift/menu.dart';
import 'package:scribbl/services/authHandler.dart';
import '../pages/selectRoom.dart';
import '../pages/Guesser_screen/guesserScreen.dart';
import '../pages/room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// List reactions = [
//   'assets/reactions/thumbUp.png',
//   'assets/reactions/thumbDown.png',
//   'assets/reactions/middleFinger.png',
//   'assets/reactions/fire.png',
//   'assets/reactions/heart.png',
// ];

class AnimatedGift extends StatefulWidget {
  @override
  _AnimatedGiftState createState() => _AnimatedGiftState();
}

class _AnimatedGiftState extends State<AnimatedGift>
    with TickerProviderStateMixin {
  bool switcher = false;
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
        if (status == AnimationStatus.completed) controllerGiftSize.forward();
        if (status == AnimationStatus.dismissed) controllerGiftSize.reset();
      });

    controllerGiftSize =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    curvedAnimationGiftSize = CurvedAnimation(
        parent: controllerGiftSize, curve: Curves.easeInOutBack);

    relativeRectTween = RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          0.0,
          totalWidth,
          totalLength * 0.4,
        ),
        end: RelativeRect.fromLTRB(
          0.0,
          0.0,
          0.0,
          0.0,
        ));
    super.initState();
  }

  @override
  void dispose() {
    controllerGiftSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (keyboardState)
        ? Container()
        : Container(
            // constraints: BoxConstraints.expand(),
            //color: Colors.red,
            child: Stack(children: <Widget>[
              PositionedTransition(
                rect: relativeRectTween.animate(controlGift),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                    ),
                    constraints: BoxConstraints.expand(),
                    width: totalWidth - 20,
                    child: GridView.builder(
                        itemCount: reactionsMenu.length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (currency.remainingCoins >=
                                  reactionsMenu[index]['price']) {
                                switcher = !switcher;
                                detuctCurrency(index);
                                addReaction(index);
                                controlGift.reverse();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ScaleTransition(
                                scale: curvedAnimationGiftSize,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[200]),
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.grey[100],
                                    ),
                                    child: Item(
                                      index: index,
                                    )),
                              ),
                            ),
                          );
                        })),
              ),
            ]),
          );
  }

  Future<void> addReaction(int index) async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'$identity reaction': '$index $switcher'});
  }
}

void detuctCurrency(int index) {
  currency.setCoins = currency.remainingCoins - reactionsMenu[index]['price'];
}

class Item extends StatelessWidget {
  final int index;
  const Item({this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 6,
            child: reactionsMenu[index]['image'],
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 10.0,
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              reactionsMenu[index]['price'].toString(),
              style: GoogleFonts.ubuntu(
                  fontSize: 13.0, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
