import 'package:flutter/material.dart';
import 'room.dart';
import 'timer.dart';
import 'guesserScreen.dart';
int ind1 = 0, ind2 = 0;
List<Offset> pointsG = <Offset>[];
int indStore;

class Guesser extends StatefulWidget {
  @override
  _GuesserState createState() => _GuesserState();
}

class _GuesserState extends State<Guesser> with TickerProviderStateMixin {
  int pStore;
  int pointerVal = 0;
  AnimationController controller;
  @override
  void initState() {
    avatarAnimation= animateAvatar.start;
    pointsG = [];
    ind1 = 0;
    ind2 = 0;
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 01),
      // value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.duration= Duration(seconds: 1);
    pointsG = [];
    if (a['length'] == 0) {
      pointsG = [];
      ind1 = 0;
      ind2 = 0;
    }
    pStore = pointerVal;
    List dex = a['indices'];
    if (a['pointer'] == 0)
      ind1 = 0;
    else
       ind1 = dex[a['pointer'] - 1];
    ind2 = dex[a['pointer']];
    pointerVal = a['pointer'];
    refactor();
    if (pStore != pointerVal) //undertesting if
    {
      if (pStore > pointerVal && a['length'] != 0) {
        ind1 = dex[a['pointer']];
        ind2 = dex[a['pointer'] + 1]; //error caught by crashlytics
        controller.duration= Duration(milliseconds: (ind2-ind1)*17);
        controller.reverse(from: 1.0);
      } 
      else{
             controller.duration= Duration(milliseconds: (ind2-ind1)*17);
             controller.forward(from: 0.0);
            }
    }
    return FractionallySizedBox(
      heightFactor: 1.0,
      child: Container(
        color: Colors.white,
        //color: textAndChat,
        child: Column(
          children: <Widget>[
            AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  return Flexible(
                    flex: 7,
                    child: new CustomPaint(
                      foregroundPainter: Signature(
                        points: pointsG,
                        animation: controller,
                      ),
                      child: Card(
                        shadowColor: Colors.white,
                        elevation: 20.0,
                        child: Container(
                            //                     decoration: BoxDecoration(
                            //                     border: Border.all(color: Colors.black,width: 3.0) ,
                            //                     image: new DecorationImage(
                            //   fit: BoxFit.fitWidth,
                            //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.10), BlendMode.dstATop),
                            //   image: new AssetImage('assets/images/scibb.jpg')
                            // ),)
                            ),
                      ),
                    ),
                  );
                }),
            Flexible(
              flex: 1,
              child: Container(
                //  color: Colors.orange[100],
                // height: 40.0,
                color: Colors.white,
                child: TimeAndWord(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Signature extends CustomPainter {
  List<Offset> points;
  Signature({this.points, this.animation}) : super(repaint: animation);
  Animation<double> animation;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 03.0;
    int diff = ind2 - ind1;
    double v = animation.value * diff;
    int val = v.toInt();
    int ind = ind1 + val;
    for (int i = 0; i < ind1; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paint);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paint);
      }
    }
    for (int i = ind1; i < ind - 1; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paint);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) =>
      animation.value != oldDelegate.animation.value ||
      oldDelegate.points != points;
}

void refactor() {
  for (int i = 0; i < a['length']; i++) {
    if (a['xpos'][i] == null) {
      pointsG = pointsG + [null];
      continue;
    }
    pointsG =
        pointsG + [Offset(alterValue2(a['xpos'][i]), alterValue(a['ypos'][i]))];
  }
}

double alterValue(double x) {
  if (x == -1)
    return x;
  else {
    double v = (x / denCanvasLength) * guessCanvasLength;
    return v;
  }
}

double alterValue2(double x) {
  if (x == -1)
    return x;
  else {
    double v = (x / denCanvasLength) * guessCanvasLength;
    v = v + ((denCanvasLength - guessCanvasLength) / 2.3);
    return v;
  }
}
