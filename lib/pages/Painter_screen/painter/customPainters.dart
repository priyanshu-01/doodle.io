import 'package:flutter/material.dart';
import '../colorPanel.dart';

class Signature extends CustomPainter {
  List<Offset> points;
  List<int> indices;
  int signatureTempInd;
  int p;
  ColorHolder colorHolder;
  Signature(
      {this.points,
      this.signatureTempInd,
      this.indices,
      this.p,
      this.colorHolder});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 03.0;
    if (paint.color != colorHolder.colors[colorHolder.selectedColorIndex])
      paint.color = colorHolder.colors[colorHolder.selectedColorIndex];
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
  ColorHolder colorHolder;
  List<int> colorIndexStack;
  Paint paintObj = new Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 03.0;
  CacheDrawing(
      {this.points,
      this.indices,
      this.p,
      this.colorHolder,
      this.colorIndexStack});
  @override
  void paint(Canvas canvas, Size size) {
    //paint.color=Colors.blue;
    for (int i = 0; i < indices[p]; i++) {
      if (indices.indexOf(i) != -1) {
        if (colorHolder.colors[colorIndexStack[indices.indexOf(i) + 1]] !=
            paintObj.color) {
          paintObj.color =
              colorHolder.colors[colorIndexStack[indices.indexOf(i) + 1]];
        }
      }

      if ((points[i] != null && points[i] != Offset(-1, -1)) &&
          (points[i + 1] != null && points[i + 1] != Offset(-1, -1))) {
        canvas.drawLine(points[i], points[i + 1], paintObj);
        //print(points[i]);
      } else if (points[i] == Offset(-1, -1) && points[i + 1] != null) {
        canvas.drawCircle(points[i + 1], 2.5, paintObj);
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
