import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/ProviderManager/data.dart';
import '../room/room.dart';
import '../timer.dart';
import 'guesserScreen.dart';
import '../Painter_screen/colorPanel.dart';

int ind1 = 0, ind2 = 0;
List pointsG = [];
int pStore = 0;
int pointerVal = 0;

class Guesser extends StatefulWidget {
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
    pStore = 0;
    pointerVal = 0;
    colorHolder = ColorHolder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 7,
          child: GuesserStrokes(
            colorHolder: colorHolder,
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: TimeAndWord(),
          ),
        ),
      ],
    );
  }
}

class Signature extends CustomPainter {
  List points;
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
    if (roomData['indices'].indexOf(ind2) != -1 && //added undertesting fix
        paintObj.color !=
            colorHolder.colors[roomData['colorIndexStack']
                [roomData['indices'].indexOf(ind2)]]) {
      //ind2 index is -1, error by crashlytics
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
  List points;
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

class GuesserStrokes extends StatefulWidget {
  final ColorHolder colorHolder;
  GuesserStrokes({
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
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding guesserStrokes.. ');
    Provider.of<CustomPainterData>(context);
    if (pStore != pointerVal) {
      if (pStore > pointerVal &&
          roomData['length'] != 0 &&
          (roomData['pointer'] + 1 != roomData['indices'].length)) {
        ind1 = roomData['indices'][roomData['pointer']];
        ind2 = roomData['indices'][roomData['pointer'] +
            1]; //error caught by crashlytics +1 ind2 out of range by 1 --temp fix applied on 24/7/2020
        controller.duration = Duration(milliseconds: (ind2 - ind1) * 17);
        controller.reverse(from: 1.0);
      } else {
        controller.duration = Duration(milliseconds: (ind2 - ind1) * 17);
        controller.forward(from: 0.0);
      }
    }
    return Stack(
      children: [
        for (int i = 0; i < roomData['indices'].indexOf(ind1); i++)
          RepaintBoundary(
            child: new CustomPaint(
              foregroundPainter: CacheGuesser(
                  points: pointsG,
                  dex: roomData['indices'],
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

Future<Map> parseGuesserStrokesData(Map computeData) async {
  List pointsG;
  int ind1;
  int ind2;
  int pStore;
  int pointerVal;
  pointsG = [];
  if (computeData["roomData"]['length'] == 0) {
    pointsG = [];
    ind1 = 0;
    ind2 = 0;
  }
  pStore = computeData['pointerVal'];
  if (computeData['roomData']['pointer'] == 0)
    ind1 = 0;
  else
    ind1 = computeData['roomData']['indices']
        [computeData['roomData']['pointer'] - 1];
  ind2 = computeData['roomData']['indices'][computeData['roomData']['pointer']];
  pointerVal = computeData['roomData']['pointer'];
  // refactor(computeData['roomData'], computeData);

  //refactoring values according to screen size
  for (int i = 0; i < computeData['roomData']['length']; i++) {
    if (computeData['roomData']['xpos'][i] == null) {
      pointsG = pointsG + [null];
      continue;
    }
    pointsG = pointsG +
        [
          Offset(alterValue2(computeData['roomData']['xpos'][i], computeData),
              alterValue(computeData['roomData']['ypos'][i], computeData))
        ];
  }

  return {
    'pointsG': pointsG,
    'ind1': ind1,
    'ind2': ind2,
    'pStore': pStore,
    'pointerVal': pointerVal
  };
}

// void refactor(Map roomData, Map computeData) {}

double alterValue(double x, Map computeData) {
  if (x == -1)
    return x;
  else {
    double v =
        (x / computeData['denCanvasLength']) * computeData['guessCanvasLength'];
    return v;
  }
}

double alterValue2(double x, Map computeData) {
  if (x == -1)
    return x;
  else {
    double v =
        (x / computeData['denCanvasLength']) * computeData['guessCanvasLength'];
    v = v +
        ((computeData['denCanvasLength'] - computeData['guessCanvasLength']) /
            2.3);
    return v;
  }
}
