import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';

class ColorHolder {
  int selectedColorIndex = 0;
  final List colors = [
    Colors.black,
    Colors.white,
    Colors.blue[600],
    Colors.green[600],
    Colors.yellow[600],
    Colors.orange,
    Colors.pink,
    Colors.red,
    Colors.purple,
    Colors.brown,
  ];
}

class ColorPanel extends StatefulWidget {
  final ColorHolder colorHolder;
  const ColorPanel({this.colorHolder});

  @override
  _ColorPanelState createState() => _ColorPanelState();
}

class _ColorPanelState extends State<ColorPanel> {
  @override
  Widget build(BuildContext context) {
    print('panel rebuilt');
    return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (var color in widget.colorHolder.colors)
              Flexible(
                child: InkWell(
                  child: ColorBuilder(
                    color: color,
                    colorHolder: widget.colorHolder,
                  ),
                  onTap: () {
                    setState(() {
                      widget.colorHolder.selectedColorIndex =
                          widget.colorHolder.colors.indexOf(color);
                    });
                  },
                ),
              )
          ],
        ));
  }
}

class ColorBuilder extends StatelessWidget {
  final ColorHolder colorHolder;
  final Color color;
  ColorBuilder({this.color, this.colorHolder});
  final double colorParentDimensions = totalLength * (2 / 3) * (1 / 11);
  final double colorDimensions = totalLength * (2 / 3) * (1 / 11) * (6.5 / 10);
  final double selectedColorDimensions =
      totalLength * (2 / 3) * (1 / 11) * (9 / 10);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: colorParentDimensions,
      width: colorParentDimensions,
      child: Center(
        child: Container(
          height: (colorHolder.colors.indexOf(color) ==
                  colorHolder.selectedColorIndex)
              ? selectedColorDimensions
              : colorDimensions,
          width: (colorHolder.colors.indexOf(color) ==
                  colorHolder.selectedColorIndex)
              ? selectedColorDimensions
              : colorDimensions,
          decoration: (color == Colors.white)
              ? BoxDecoration(
                  shape: BoxShape.circle, color: color, border: Border.all())
              : BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
        ),
      ),
    );
  }
}
