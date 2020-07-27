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
                  enableFeedback: false,
                  child: (widget.colorHolder.colors.indexOf(color) ==
                          widget.colorHolder.selectedColorIndex)
                      ? SelectedColorBuilder(
                          color: color,
                          colorHolder: widget.colorHolder,
                        )
                      : ColorBuilder(
                          color: color,
                          colorHolder: widget.colorHolder,
                        ),
                  onTap: () {
                    audioPlayer.playSound('colorChange');
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: colorParentDimensions,
      width: colorParentDimensions,
      child: Center(
        child: Container(
          height:
              // (colorHolder.colors.indexOf(color) ==
              //         colorHolder.selectedColorIndex)
              //     ? selectedColorDimensions
              // :
              colorDimensions,
          width:
              // (colorHolder.colors.indexOf(color) ==
              //         colorHolder.selectedColorIndex)
              //     ? selectedColorDimensions
              //     :
              colorDimensions,
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

class SelectedColorBuilder extends StatefulWidget {
  final ColorHolder colorHolder;
  final Color color;
  // ColorBuilder();
  SelectedColorBuilder({this.color, this.colorHolder});
  @override
  _SelectedColorBuilderState createState() => _SelectedColorBuilderState();
}

class _SelectedColorBuilderState extends State<SelectedColorBuilder>
    with SingleTickerProviderStateMixin {
  AnimationController scaleAnimation;
  CurvedAnimation scaleCurve;
  final double colorDimensions = totalLength * (2 / 3) * (1 / 11) * (6.5 / 10);

  final double selectedColorDimensions =
      totalLength * (2 / 3) * (1 / 11) * (9 / 10);
  final double colorParentDimensions = totalLength * (2 / 3) * (1 / 11);
  double _dimensions;
  @override
  void initState() {
    scaleAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    scaleCurve =
        CurvedAnimation(curve: Curves.easeInOutBack, parent: scaleAnimation);
    _dimensions = colorDimensions;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _dimensions = selectedColorDimensions;
      });
      // _dimensions = selectedColorDimensions;
      scaleAnimation.forward(from: 0.5);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      height: colorParentDimensions,
      width: colorParentDimensions,
      child: Center(
        child: ScaleTransition(
          scale: scaleCurve,
          child: Container(
            height: _dimensions,
            //  (widget.colorHolder.colors.indexOf(color) ==
            //         widget.colorHolder.selectedColorIndex)
            //     ? selectedColorDimensions
            //     : colorDimensions,
            width: _dimensions,
            //  (widget.colorHolder.colors.indexOf(color) ==
            //         widget.colorHolder.selectedColorIndex)
            //     ? selectedColorDimensions
            //     : colorDimensions,
            decoration: (widget.color == Colors.white)
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    border: Border.all())
                : BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
          ),
        ),
      ),
    );
  }
}
