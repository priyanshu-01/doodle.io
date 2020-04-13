import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'chooseWord.dart';
import 'timer.dart';
  
    List<Offset> pointsD = <Offset>[];
class Painter extends StatefulWidget {
  @override
  PainterState createState() => new PainterState();
}
class PainterState extends State<Painter> {
  var listX = new List();
  var listY = new List();
   int tempInd =0;
  void clearPoints(){
    setState(() {
      pointsD.clear();
    });
  }
  @override
  void initState(){
    pointsD=[];
    listX=[];
    listY=[];
    tempInd=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
        return Column(
          children: <Widget>[
            new GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox object = context.findRenderObject();
                    Offset _localPosition =
            object.globalToLocal(details.globalPosition);
                    pointsD = new List.from(pointsD)..add(_localPosition);
                    listY.add(_localPosition.dy);
                    listX.add(_localPosition.dx);
                    tempInd++;
                    
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  pointsD.add(null);
                  listY.add(null);
                    listX.add(null);
                    tempInd++;
                    Firestore.instance
                    .collection('rooms')
                      .document(documentid)
            .updateData({
              'xpos': listX,
              'ypos': listY,
              'length' : tempInd
            });
                } ,
                child: new CustomPaint(
                  child: Container(
                    child: Container(color: Colors.white,),
                    
                    height: 350.0,
                    width: 400.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 4.0)
                        ),
                  ),
                foregroundPainter: new Signature(points: pointsD),
                 size: Size.infinite,
                // size: Size.fromHeight(400.0)
                ),
              ),
              Container(
                      height: 50.0,
                      color: Colors.orange[600],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Time(),
                        Text('$word'),   
                        IconButton(
                      
                      icon: Icon(Icons.delete, size: 30.0,color: Colors.white,),
                     // alignment: Alignment.bottomRight,
                      onPressed: (){
                              clearPoints();
                              listX=[];
                              listY=[];
                              tempInd=0;
                              Firestore.instance
                                           .collection('rooms')
                                           .document(documentid)
                                           .updateData({
                                    'xpos': listX,
                                    'ypos': listY,
                                    'length' : tempInd
                                  });
                              
                            },
                    ),
                    // IconButton(icon: Icon(Icons.refre),)
                        
                  // Text('67'),
                      ],),
                    ),
          ],
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