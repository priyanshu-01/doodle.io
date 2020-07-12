import 'package:flutter/material.dart';
import '../room/room.dart';
import '../timer.dart';
import 'guesserScreen.dart';
import '../Painter_screen/colorPanel.dart';

int ind1 = 0, ind2 = 0;
List<Offset> pointsG = <Offset>[];
int indStore; //might be useless
int pStore;
int pointerVal = 0;

class Guesser extends StatefulWidget {
  // AnimationController controller;
  @override
  _GuesserState createState() => _GuesserState();
}

class _GuesserState extends State<Guesser> {
  ColorHolder colorHolder;
  @override
  void initState() {
    avatarAnimation = animateAvatar.start;
    pointsG = [];
    ind1 = 0;
    ind2 = 0;
    colorHolder = ColorHolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pointsG = [];
    if (roomData['length'] == 0) {
      pointsG = [];
      ind1 = 0;
      ind2 = 0;
    }
    pStore = pointerVal;
    List dex = roomData['indices'];
    if (roomData['pointer'] == 0)
      ind1 = 0;
    else
      ind1 = dex[roomData['pointer'] - 1];
    ind2 = dex[roomData['pointer']];
    pointerVal = roomData['pointer'];
    refactor();

    return Column(
      children: <Widget>[
        Flexible(
          flex: 7,
          child: GuesserStrokes(
            colorHolder: colorHolder,
            dex: dex,
          ),
        ),
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
    );
  }
}

class Signature extends CustomPainter {
  List<Offset> points;
  Animation<double> animation;
  ColorHolder colorHolder;
  Paint paintObj = new Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 03.0;
  Signature({this.points, this.animation, this.colorHolder})
      : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    if (paintObj.color !=
        colorHolder.colors[roomData['colorIndexStack']
            [roomData['indices'].indexOf(ind2)]]) {
      paintObj.color = colorHolder.colors[roomData['colorIndexStack']
          [roomData['indices'].indexOf(ind2)]];
    }
    int diff = ind2 - ind1;
    double v = animation.value * diff;
    int val = v.toInt();
    int ind = ind1 + val;
    for (int i = ind1; i < ind - 1; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paintObj);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paintObj);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    if (animation.value != oldDelegate.animation.value ||
        oldDelegate.points != points) {
      return true;
    } else
      return false;
  }
}

class CacheGuesser extends CustomPainter {
  List<Offset> points;
  List dex;
  int sketcher;
  Color color;
  ColorHolder colorHolder;
  Paint paintObj = new Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 03.0;
  CacheGuesser(
      {this.points, this.dex, this.sketcher, this.color, this.colorHolder});
  @override
  void paint(Canvas canvas, Size size) {
    paintObj.color = color;
    for (int i = dex[sketcher]; i < dex[sketcher + 1]; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paintObj);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paintObj);
      }
    }
  }

  @override
  bool shouldRepaint(CacheGuesser oldDelegate) => false;
}

void refactor() {
  for (int i = 0; i < roomData['length']; i++) {
    if (roomData['xpos'][i] == null) {
      pointsG = pointsG + [null];
      continue;
    }
    pointsG = pointsG +
        [
          Offset(
              alterValue2(roomData['xpos'][i]), alterValue(roomData['ypos'][i]))
        ];
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

class GuesserStrokes extends StatefulWidget {
  final List dex;
  final ColorHolder colorHolder;
  GuesserStrokes({
    @required this.dex,
    @required this.colorHolder,
  });

  @override
  _GuesserStrokesState createState() => _GuesserStrokesState();
}

class _GuesserStrokesState extends State<GuesserStrokes>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 01),
      // value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (pStore != pointerVal) //undertesting if
    {
      if (pStore > pointerVal && roomData['length'] != 0) {
        ind1 = widget.dex[roomData['pointer']];
        ind2 =
            widget.dex[roomData['pointer'] + 1]; //error caught by crashlytics
        controller.duration = Duration(milliseconds: (ind2 - ind1) * 17);
        controller.reverse(from: 1.0);
      } else {
        controller.duration = Duration(milliseconds: (ind2 - ind1) * 17);
        controller.forward(from: 0.0);
      }
    }
    return Stack(
      children: [
        for (int i = 0; i < widget.dex.indexOf(ind1); i++)
          RepaintBoundary(
            child: new CustomPaint(
              foregroundPainter: CacheGuesser(
                  points: pointsG,
                  dex: widget.dex,
                  sketcher: i,
                  color: widget
                      .colorHolder.colors[roomData['colorIndexStack'][i + 1]],
                  colorHolder: widget.colorHolder),
              child: Container(),
            ),
          ),
        RepaintBoundary(
          child: new CustomPaint(
            painter: Signature(
                points: pointsG,
                animation: controller,
                colorHolder: widget.colorHolder),
            child: Container(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
