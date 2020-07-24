import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/gift/menu.dart';
import 'package:scribbl/services/authHandler.dart';
import '../pages/Select_room/selectRoom.dart';
import '../pages/Guesser_screen/guesserScreen.dart';
import '../pages/room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Image coinImage = const Image(image: AssetImage('assets/icons/coin.png'));

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
  List offsetAnimations;
  @override
  void initState() {
    controlGift = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward)
          controllerGiftSize.forward(from: 0.0);
        if (status == AnimationStatus.dismissed) controllerGiftSize.reset();
      });

    controllerGiftSize =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    curvedAnimationGiftSize =
        CurvedAnimation(parent: controllerGiftSize, curve: Curves.elasticInOut);

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

    offsetAnimations = [
      Tween<Offset>(
        begin: const Offset(-0.5, -0.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
      Tween<Offset>(
        begin: const Offset(-1.0, -0.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
      Tween<Offset>(
        begin: const Offset(-1.5, -0.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
      Tween<Offset>(
        begin: const Offset(-0.5, -1.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
      Tween<Offset>(
        begin: const Offset(-1.0, -1.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
      Tween<Offset>(
        begin: const Offset(-1.5, -1.5),
        end: Offset.zero,
      ).animate(curvedAnimationGiftSize),
    ];

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
            child: Stack(children: <Widget>[
              PositionedTransition(
                rect: relativeRectTween.animate(controlGift),
                child: Container(
                    constraints: BoxConstraints.expand(),
                    // width: totalWidth - 20,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue[300], Colors.blue[600]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: reactionsMenu.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
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
                              child: (index <= 5)
                                  ? SlideTransition(
                                      position: offsetAnimations[index],
                                      child: ScaleTransition(
                                        scale: curvedAnimationGiftSize,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blue[200]),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              // color: Colors.grey[100],
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.white,
                                                    // Colors.yellow[100],
                                                    Colors.yellow[400]
                                                  ]),
                                            ),
                                            child: Item(
                                              index: index,
                                            )),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.blue[200]),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        // color: Colors.grey[100],
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white,
                                              Colors.yellow[400]
                                            ]),
                                      ),
                                      child: Item(
                                        index: index,
                                      )),
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
            flex: 10,
            child: reactionsMenu[index]['image'],
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 10.0,
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.blue[700],
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[800], Colors.blue[300]]),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(child: coinImage),
                    SizedBox(
                      width: 4.0,
                    ),
                    Flexible(
                      child: Text(
                        reactionsMenu[index]['price'].toString(),
                        style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
