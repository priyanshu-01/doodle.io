import 'package:flutter/material.dart';
import 'package:scribbl/pages/selectRoom.dart';

final List colors = [
  Colors.black,
  Colors.brown,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.red,
  Colors.purple
];

class ColorPanel extends StatelessWidget {
  const ColorPanel();

  @override
  Widget build(BuildContext context) {
    print('panel rebuilt');
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[for (var color in colors) ColorBuilder(color: color)],
    ));
  }
}

class ColorBuilder extends StatelessWidget {
  final Color color;
  ColorBuilder({this.color});
  final double colorParentDimensions = totalLength * (2 / 3) * (1 / 11);
  final double colorDimensions = totalLength * (2 / 3) * (1 / 11) * (8 / 10);
  final double colorPadding = totalLength * (2 / 3) * (1 / 11) * (2 / 10);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: colorParentDimensions,
        width: colorParentDimensions,
        child: Center(
          child: Container(
            height: colorDimensions,
            width: colorDimensions,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
