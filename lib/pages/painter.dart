import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'chooseWord.dart';

class Painter extends StatefulWidget {
  @override
  _PainterState createState() => new _PainterState();
}

class _PainterState extends State<Painter> {
  List<Offset> _points = <Offset>[];
  var list_x = new List();
  var list_y = new List();
  int ind =0;


  @override
  Widget build(BuildContext context) {
    
        return Flexible(
            child: Container(
              constraints: BoxConstraints.expand(),
            color: Colors.yellow[50],
            // decoration: BoxDecoration(
            //   border: Border.all(

            //   ),
            //   //color: Colors.black
            // ),
            child: new GestureDetector(

                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox object = context.findRenderObject();
                    Offset _localPosition =
            object.globalToLocal(details.globalPosition);
                    _points = new List.from(_points)..add(_localPosition);
                    list_y.add(_localPosition.dy);
                    list_x.add(_localPosition.dx);
                    ind++;
                    
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  _points.add(null);
                  list_y.add(null);
                    list_x.add(null);
                    ind++;
                    Firestore.instance
                    .collection('rooms')
                      .document(documentid)
            .updateData({
              'xpos': list_x,
              'ypos': list_y,
              'length' : ind
            });
                } ,
                child: new CustomPaint(
                painter: new Signature(points: _points),
                 size: Size.infinite,
                // size: Size.fromHeight(400.0)
                ),
              ),
          
          ),
        );

  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 05.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
        //print(points[i]);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}