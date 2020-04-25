import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
import 'chooseWord.dart';
import 'timer.dart';
import 'package:google_fonts/google_fonts.dart';
class Painter extends StatefulWidget {
  @override
  PainterState createState() => new PainterState();
}
class PainterState extends State<Painter> {
   List<Offset> pointsD = <Offset>[];
  List listX = new List();
  List listY = new List();
   int tempInd =0;
   List<int> indices = [0];
   int p=0;
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
            Flexible(
              flex:6,
                          child: new GestureDetector(
                            onPanStart:(DragStartDetails details) {
                    setState(() {
                      RenderBox object = context.findRenderObject();
                      Offset _localPosition =
              object.globalToLocal(details.globalPosition);
              if(indices[p]!=tempInd){
                print('success');
                  listX= truncate3(listX,indices[p]);
                  listY= truncate3(listY,indices[p]);
                  pointsD= truncate2(pointsD,indices[p]);
                  indices=truncate(indices, p);
                  pointsD.add(null);
                  listY.add(null);
                  listX.add(null);
                  tempInd=indices[p]+1;
              }
                      pointsD = new List.from(pointsD)..add(_localPosition);
                      listY.add(_localPosition.dy);
                      listX.add(_localPosition.dx);
                      tempInd++;
                      indices.add(tempInd);
                      p=p+1;
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
                      indices[p]= tempInd;
                    });
                  },

                  onPanEnd: (DragEndDetails details) {
                    pointsD.add(null);
                    listY.add(null);
                      listX.add(null);
                      tempInd++;
                      indices[p]=tempInd;
                      Firestore.instance
                      .collection('rooms')
                        .document(documentid)
              .updateData({
                'xpos': listX,
                'ypos': listY,
                'length' : tempInd,
                'indices': indices,
                'pointer': p
              });
                  } ,
             onTapUp: (TapUpDetails details){
                print('point drawn');
                    setState(() {
                      RenderBox obj = context.findRenderObject();
                      Offset _localP =
              obj.globalToLocal(details.globalPosition);
                           if(indices[p]!=tempInd){
                  listX= truncate3(listX,indices[p]);
                  listY= truncate3(listY,indices[p]);
                  pointsD= truncate2(pointsD,indices[p]);
                   indices=truncate(indices, p);
              }
                      pointsD.add(Offset(-1.0,-1.0));
                      listY.add(-1.0);
                      listX.add(-1.0);
                      tempInd=indices[p]+1;
                      pointsD = new List.from(pointsD)..add(_localP);
                      listY.add(_localP.dy);
                      listX.add(_localP.dx);
                      tempInd++;
                      pointsD.add(null);
                    listY.add(null);
                      listX.add(null);
                      tempInd++;
                      indices.add(tempInd);
                      p=p+1;
                      indices[p]= tempInd;
                      Firestore.instance
                      .collection('rooms')
                        .document(documentid)
              .updateData({
                'xpos': listX,
                'ypos': listY,
                'length' : tempInd,
                'indices':indices,
                'pointer': p
              });
                    });
                  },
                  child: new CustomPaint(
                    child: Container(
                     // child: Container(color: Colors.white,),
                      // height: 350.0,
                      // width: 400.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                          border: Border.all(color: Colors.black,width: 4.0),
                          image: new DecorationImage(
                fit: BoxFit.fitWidth,
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.10), BlendMode.dstATop),
                image: new AssetImage('assets/images/scibb.jpg')
              )
                          ),
                    ),
                  foregroundPainter: new Signature(points: pointsD,indices: indices,p: p),
                   size: Size.infinite,
                  // size: Size.fromHeight(400.0)
                  ),
                ),
            ),
              Flexible(
                flex:1,
                              child: Container(
                     //   height: 50.0,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                          Time(),
                          Text('$word', style: GoogleFonts.lexendGiga(),),   
                          IconButton(icon: Icon(Icons.settings_backup_restore,),
                          onPressed: (){
                            if(p!=0)
                            {
                             setState(() {
                              p=p-1;
                            });
                           Firestore.instance
                                        .collection('rooms')
                                          .document(documentid)
                                .updateData({
                                  'pointer' : p
                                });
                            }
                            
                          },),
                           IconButton(icon: Icon(Icons.forward_5,),
                          onPressed: (){
                            if(p!=indices.length-1)
                            {
                            setState(() {
                              p=p+1;
                            });
                            Firestore.instance
                            .collection('rooms')
                            .document(documentid)
                            .updateData({
                            'pointer' :p
                            });
                            }
                            
                          },),
                          IconButton(
                        
                        icon: Icon(Icons.delete, size: 30.0,color: Colors.black,),
                       // alignment: Alignment.bottomRight,
                        onPressed: (){
                                clearPoints();
                                listX=[];
                                listY=[];
                                tempInd=0;
                                p=0;
                                indices=[0];
                                Firestore.instance
                                             .collection('rooms')
                                             .document(documentid)
                                             .updateData({
                                      'xpos': listX,
                                      'ypos': listY,
                                      'length' : tempInd,
                                      'indices': indices,
                                      'pointer': p
                                    });
                                
                              },
                      ),
                      // IconButton(icon: Icon(Icons.refre),)
                          
                    // Text('67'),
                        ],),
                      ),
              ),
          ],
        );

  }
}

class Signature extends CustomPainter {
  List<Offset> points;
  List<int> indices;
  int p;
  Signature({this.points, this.indices, this.p});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 04.0;
    for (int i = 0; i < indices[p]-1; i++) {
      if ((points[i] != null && points[i]!=Offset(-1,-1)) &&( points[i + 1] != null && points[i+1]!=Offset(-1,-1))) {
        canvas.drawLine(points[i], points[i + 1], paint);
        //print(points[i]);
      }
      else if( points[i]==Offset(-1,-1) && points[i+1]!=null)
      {
        canvas.drawCircle(points[i+1], 2.5, paint);
      }
    }
  }
  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points || oldDelegate.p!=p;
}
List truncate(List a, ind){
  List<int> modified = new List();
  for(int i=0;i<=ind;i++){
    modified.add(a[i]);
  }
  return modified;
}
List truncate2(List a, ind){
  List<Offset> modified = new List();
  for(int i=0;i<=ind;i++){
    modified.add(a[i]);
  }
  return modified;
}
List truncate3(List a, ind){
  List<double> modified = new List();
  for(int i=0;i<=ind;i++){
    modified.add(a[i]);
  }
  return modified;
}