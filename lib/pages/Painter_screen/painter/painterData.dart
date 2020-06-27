import 'dart:ui';
import 'package:flutter/material.dart';

import '../colorPanel.dart';
import 'crud.dart';

class PainterData {
  List<Offset> pointsD = <Offset>[];
  List listX = new List();
  List listY = new List();
  int tempInd = 0;
  List<int> indices = [0];
  List<Color> strokeColor = [Colors.black];
  int p = 0;
  int signatureTempInd = 0;
  List<int> colorIndexStack = [0];
  StringOperations stringOperations;
  ColorHolder colorHolder;
  CRUD crud;
}
