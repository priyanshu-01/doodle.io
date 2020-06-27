import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../room/room.dart';
import '../timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colorPanel.dart';

class Painter extends StatefulWidget {
  @override
  PainterState createState() => new PainterState();
}

class PainterState extends State<Painter> {
  List<Offset> pointsD = <Offset>[];
  List listX = new List();
  List listY = new List();
  int tempInd = 0;
  List<int> indices = [0];
  List<Color> strokeColor = [Colors.black];
  int p = 0;
  int signatureTempInd = 0;

  void clearPoints() {
    setState(() {
      pointsD.clear();
    });
  }

  @override
  void initState() {
    pointsD = [];
    listX = [];
    listY = [];
    tempInd = 0;
    indices = [0];
    p = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 9,
            child: Stack(
              children: [
                RepaintBoundary(
                  child: CustomPaint(
                    child: Container(
                      color: Colors.white,
                      constraints: BoxConstraints.expand(),
                    ),
                    foregroundPainter: new CacheDrawing(
                      points: pointsD,
                      indices: indices,
                      p: p,
                    ),
                    size: Size.infinite,
                  ),
                ),
                RepaintBoundary(
                  child: new GestureDetector(
                    onPanStart: (DragStartDetails details) {
                      setState(() {
                        RenderBox object = context.findRenderObject();
                        Offset _localPosition =
                            object.globalToLocal(details.globalPosition);
                        if (indices[p] != tempInd) {
                          listX = truncate3(listX, indices[p]);
                          listY = truncate3(listY, indices[p]);
                          pointsD = truncate2(pointsD, indices[p]);
                          indices = truncate(indices, p);
                          pointsD.add(null);
                          listY.add(null);
                          listX.add(null);
                          tempInd = indices[p] + 1;
                        }
                        pointsD = new List.from(pointsD)..add(_localPosition);
                        listY.add(_localPosition.dy);
                        listX.add(_localPosition.dx);
                        tempInd++;
                        signatureTempInd = tempInd;
                        // indices.add(tempInd);
                        // p = p + 1;
                      });
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        RenderBox object = context.findRenderObject();
                        Offset _localPosition =
                            object.globalToLocal(details.globalPosition);
                        pointsD = new List.from(pointsD)..add(_localPosition);
                        listY.add(_localPosition.dy);
                        listX.add(_localPosition.dx);
                        tempInd++;
                        signatureTempInd = tempInd;
                        // indices[p] = tempInd;
                      });
                    },
                    onPanEnd: (DragEndDetails details) {
                      setState(() {
                        pointsD.add(null);
                        listY.add(null);
                        listX.add(null);
                        tempInd++;
                        indices.add(tempInd);
                        p = p + 1;
                        indices[p] = tempInd;
                        signatureTempInd = tempInd;
                        updateStroke();
                      });
                    },

                    //onTapUp: (TapUpDetails details){tapFunction(details);},
                    child: new CustomPaint(
                      child: Container(
                        // color: Colors.pink,
                        constraints: BoxConstraints.expand(),
                      ),
                      painter: new Signature(
                          points: pointsD,
                          signatureTempInd: signatureTempInd,
                          indices: indices,
                          p: p),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ],
            )),
        Flexible(
          flex: 1,
          child: Container(
            //   height: 50.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  '$word',
                  style: GoogleFonts.lexendGiga(),
                ),
                Time(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: InkWell(
                        child: const Image(
                          image: AssetImage('assets/icons/arrow_left.png'),
                        ),
                        onTap: () {
                          if (p != 0) {
                            setState(() {
                              p = p - 1;
                              signatureTempInd = indices[p];
                            });
                            updatePointer();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: InkWell(
                        onTap: () {
                          if (p != indices.length - 1) {
                            setState(() {
                              p = p + 1;
                              signatureTempInd = indices[p];
                            });
                            updatePointer();
                          }
                        },
                        child: const Image(
                          image: AssetImage('assets/icons/arrow_right.png'),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        clearPoints();
                        listX = [];
                        listY = [];
                        tempInd = 0;
                        p = 0;
                        indices = [0];
                        updateStroke();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: const ColorPanel(),
        )
      ],
    );
  }

  Future<void> updateStroke() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({
      'xpos': listX,
      'ypos': listY,
      'length': tempInd,
      'indices': indices,
      'pointer': p
    });
  }

  Future<void> updatePointer() async {
    await Firestore.instance
        .collection('rooms')
        .document(documentid)
        .updateData({'pointer': p});
  }

  void tapFunction(TapUpDetails details) {
    print('point drawn');
    setState(() {
      RenderBox obj = context.findRenderObject();
      Offset _localP = obj.globalToLocal(details.globalPosition);
      if (indices[p] != tempInd) {
        listX = truncate3(listX, indices[p]);
        listY = truncate3(listY, indices[p]);
        pointsD = truncate2(pointsD, indices[p]);
        indices = truncate(indices, p);
      }
      pointsD.add(Offset(-1.0, -1.0));
      listY.add(-1.0);
      listX.add(-1.0);
      tempInd = indices[p] + 1;
      pointsD = new List.from(pointsD)..add(_localP);
      listY.add(_localP.dy);
      listX.add(_localP.dx);
      tempInd++;
      pointsD.add(null);
      listY.add(null);
      listX.add(null);
      tempInd++;
      indices.add(tempInd);
      p = p + 1;
      indices[p] = tempInd;
      updateStroke();
    });
  }
}

class Signature extends CustomPainter {
  List<Offset> points;
  List<int> indices;
  int signatureTempInd;
  int p;
  Signature({this.points, this.signatureTempInd, this.indices, this.p});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 03.0;
    for (int i = (p == 0) ? 0 : indices[p]; i < signatureTempInd - 1; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paint);
        //print(points[i]);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    if (oldDelegate.points != points || oldDelegate.p != p) {
      return true;
    } else
      return false;
  }
}

class CacheDrawing extends CustomPainter {
  List<Offset> points;
  List<int> indices;
  int p;
  CacheDrawing({this.points, this.indices, this.p});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 03.0;
    //paint.color=Colors.blue;
    for (int i = 0; i < ((p == 0) ? 0 : indices[p]) - 1; i++) {
      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paint);
        //print(points[i]);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CacheDrawing oldDelegate) {
    if (oldDelegate.p != p) {
      return true;
    } else
      return false;
  }
}

List truncate(List a, ind) {
  List<int> modified = new List();
  for (int i = 0; i <= ind; i++) {
    modified.add(a[i]);
  }
  return modified;
}

List truncate2(List a, ind) {
  List<Offset> modified = new List();
  for (int i = 0; i <= ind; i++) {
    modified.add(a[i]);
  }
  return modified;
}

List truncate3(List a, ind) {
  List<double> modified = new List();
  for (int i = 0; i <= ind; i++) {
    modified.add(a[i]);
  }
  return modified;
}
