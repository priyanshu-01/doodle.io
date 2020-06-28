import 'package:flutter/material.dart';
import '../../room/room.dart';
import '../../timer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colorPanel.dart';
import 'customPainters.dart';
import 'crud.dart';
import 'painterData.dart';

class Painter extends StatefulWidget {
  @override
  PainterState createState() => new PainterState();
}

class PainterState extends State<Painter> {
  PainterData painterData;
  void clearPoints() {
    setState(() {
      painterData.pointsD.clear();
    });
  }

  @override
  void initState() {
    painterData = PainterData();
    painterData.pointsD = [];
    painterData.listX = [];
    painterData.listY = [];
    painterData.tempInd = 0;
    painterData.indices = [0];
    painterData.colorIndexStack = [0];
    painterData.p = 0;
    painterData.colorHolder = ColorHolder();
    painterData.stringOperations = StringOperations();
    painterData.crud = CRUD(painterData: painterData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 9,
            child: SingleStroke(
              painterData: painterData,
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
                          if (painterData.p != 0) {
                            setState(() {
                              painterData.p = painterData.p - 1;
                              painterData.signatureTempInd =
                                  painterData.indices[painterData.p];
                            });
                            painterData.crud.updatePointer();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: InkWell(
                        onTap: () {
                          if (painterData.p != painterData.indices.length - 1) {
                            setState(() {
                              painterData.p = painterData.p + 1;
                              painterData.signatureTempInd =
                                  painterData.indices[painterData.p];
                            });
                            painterData.crud.updatePointer();
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
                        color: Color(0xFF504A4B),
                      ),
                      onPressed: () {
                        clearPoints();
                        painterData.listX = [];
                        painterData.listY = [];
                        painterData.tempInd = 0;
                        painterData.signatureTempInd = 0;
                        painterData.p = 0;
                        painterData.indices = [0];
                        painterData.colorIndexStack = [0];
                        painterData.crud.updateStroke();
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
          child: ColorPanel(
            colorHolder: painterData.colorHolder,
          ),
        )
      ],
    );
  }
}

class SingleStroke extends StatefulWidget {
  final PainterData painterData;
  SingleStroke({this.painterData});
  @override
  _SingleStrokeState createState() =>
      _SingleStrokeState(painterData: painterData);
}

class _SingleStrokeState extends State<SingleStroke> {
  final PainterData painterData;
  _SingleStrokeState({this.painterData});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(),
            ),
            foregroundPainter: new CacheDrawing(
                points: painterData.pointsD,
                indices: painterData.indices,
                p: painterData.p,
                colorHolder: painterData.colorHolder,
                colorIndexStack: painterData.colorIndexStack),
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
                if (painterData.indices[painterData.p] != painterData.tempInd) {
                  painterData.listX = painterData.stringOperations.truncate3(
                      painterData.listX, painterData.indices[painterData.p]);
                  painterData.listY = painterData.stringOperations.truncate3(
                      painterData.listY, painterData.indices[painterData.p]);
                  painterData.pointsD = painterData.stringOperations.truncate2(
                      painterData.pointsD, painterData.indices[painterData.p]);
                  painterData.indices = painterData.stringOperations
                      .truncate(painterData.indices, painterData.p);
                  painterData.colorIndexStack = painterData.stringOperations
                      .truncate(painterData.colorIndexStack, painterData.p);
                  painterData.pointsD.add(null);
                  painterData.listY.add(null);
                  painterData.listX.add(null);
                  painterData.tempInd = painterData.indices[painterData.p] + 1;
                }
                painterData.pointsD = new List.from(painterData.pointsD)
                  ..add(_localPosition);
                painterData.listY.add(_localPosition.dy);
                painterData.listX.add(_localPosition.dx);
                painterData.tempInd++;
                painterData.signatureTempInd = painterData.tempInd;
                // painterData.indices.add(painterData.tempInd);
                // p = p + 1;
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                painterData.pointsD = new List.from(painterData.pointsD)
                  ..add(_localPosition);
                painterData.listY.add(_localPosition.dy);
                painterData.listX.add(_localPosition.dx);
                painterData.tempInd++;
                painterData.signatureTempInd = painterData.tempInd;
                // painterData.indices[p] = painterData.tempInd;
              });
            },
            onPanEnd: (DragEndDetails details) {
              setState(() {
                painterData.pointsD.add(null);
                painterData.listY.add(null);
                painterData.listX.add(null);
                painterData.tempInd++;
                painterData.indices.add(painterData.tempInd);
                painterData.colorIndexStack
                    .add(painterData.colorHolder.selectedColorIndex);
                painterData.p = painterData.p + 1;
                painterData.indices[painterData.p] = painterData.tempInd;
                painterData.colorIndexStack[painterData.p] =
                    painterData.colorHolder.selectedColorIndex;
                painterData.signatureTempInd = painterData.tempInd;
                painterData.crud.updateStroke();
              });
            },

            //onTapUp: (TapUpDetails details){tapFunction(details);},
            child: new CustomPaint(
              child: Container(
                // color: Colors.pink,
                constraints: BoxConstraints.expand(),
              ),
              painter: new Signature(
                  points: painterData.pointsD,
                  signatureTempInd: painterData.signatureTempInd,
                  indices: painterData.indices,
                  p: painterData.p,
                  colorHolder: painterData.colorHolder),
              size: Size.infinite,
            ),
          ),
        )
      ],
    );
  }
}
