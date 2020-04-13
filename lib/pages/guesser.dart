import 'package:flutter/material.dart';
import 'room.dart';
import 'timer.dart';
int ind1=0,ind2=0;
  List<Offset> pointsG = <Offset>[];
// Future<void> getDetail() async{
//   a= await Firestore.instance.collection('rooms').document(documentid).get();
// }
class Guesser extends StatefulWidget {
  @override
  _GuesserState createState() => _GuesserState();
}
class _GuesserState extends State<Guesser> with TickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState(){
    pointsG=[];
    super.initState();
    controller= AnimationController(
      vsync: this,
    duration: Duration(seconds: 01),
   // value: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
    );
    //controller.reverse(from: 1.1);
  }
  
  @override
  Widget build(BuildContext context) {
        //var a = snapshot.data.documents[0];
      if(a['length']==0){
        pointsG=[];
      }
      ind1=ind2;
      if(a['length']!=0)
      ind2= a['length'];
      else
      ind2=0;
      for(int i=ind1;i<ind2;i++){
            if(a['xpos'][i]==null)
            {
             pointsG = pointsG + [null];
              continue;
            }
            pointsG = pointsG+ [Offset(a['xpos'][i],
              a['ypos'][i])];
             }
            //  ind1= ind2;
      //print(a['length']);
      print('from guesser.dart');
      print(ind1);
      print(ind2);
      controller.forward(from: 0.0);
          return Column(
            children: <Widget>[
              AnimatedBuilder(animation: controller,
               builder: (BuildContext context, Widget child){
                 return new CustomPaint(  
                    child: Container(
                       height: 350.0,
                        width: 400.0,
                        //constraints: BoxConstraints.expand(),
                        //color: Colors.blue,
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                        ),
                      ),  
                    //size: Size(200,200),
                    //size: Size.infinite,
              foregroundPainter: Signature(
                points: pointsG,
                   animation: controller,
                   ),
              // size: Size.infinite,
              );
               }),
                Container(
                           height: 50.0,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: <Widget>[
                               Time(),
                               WordHint(),
                             ], 
                           ),
                         ),
            ],
          );
  }

}
class Signature extends CustomPainter {
  List<Offset> points;
  Signature({this.points, this.animation}) : super(repaint: animation);
  Animation<double> animation;
  @override
  void paint (Canvas canvas, Size size){
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 05.0;
    
    int diff= ind2-ind1;
    
    double v= animation.value * diff;
    int val = v.toInt();
    int ind = ind1+ val;
          for (int i = 0; i < ind1; i++) {

     if (points[i] != null && points[i + 1] != null) {

          canvas.drawLine(points[i], points[i + 1], paint);
      } 
      
    }

          
          for(int i=ind1;i<ind;i++)
          {
            if (points[i] != null && points[i + 1] != null) {
            canvas.drawLine(points[i], points[i+1], paint);
             }
          }
    
      

  }

  @override
  bool shouldRepaint(Signature oldDelegate) =>   animation.value != oldDelegate.animation.value
  || oldDelegate.points != points
   ;
}
