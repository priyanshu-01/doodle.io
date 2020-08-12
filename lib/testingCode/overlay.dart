import 'package:flutter/material.dart';

class PushOverlayButton extends StatefulWidget {
  @override
  _PushOverlayButtonState createState() => _PushOverlayButtonState();
}

class _PushOverlayButtonState extends State<PushOverlayButton> {
  OverlayBuilder overlayBuilder;
  @override
  void initState() {
    overlayBuilder = OverlayBuilder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(onPressed: () {
              overlayBuilder.show(
                  context, MyOverlayWidget(overlayBuilder: overlayBuilder));
            }),
            RaisedButton(onPressed: () {
              overlayBuilder.show(
                  context, MyOverlayWidget2(overlayBuilder: overlayBuilder));
            }),
          ],
        ),
      ),
    );
  }
}

class OverlayBuilder {
  OverlayEntry overlayEntry;

  OverlayEntry buildOverlay(Widget myOverlayWidget) {
    return OverlayEntry(
      builder: (context) {
        return Stack(children: <Widget>[
          Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black,
              constraints: BoxConstraints.expand(),
            ),
          ),
          Center(child: Container(child: myOverlayWidget)),
        ]);
      },
    );
  }

  void show(BuildContext context, Widget myOverlayWidget) {
    overlayEntry = buildOverlay(myOverlayWidget);
    Overlay.of(context).insert(overlayEntry);
  }

  void hide() {
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
  }
}

class MyOverlayWidget extends StatelessWidget {
  final OverlayBuilder overlayBuilder;
  MyOverlayWidget({@required this.overlayBuilder});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          overlayBuilder.hide();
        },
        child: Container(
          height: 100,
          width: 100,
          color: Colors.blue,
        ));
  }
}

class MyOverlayWidget2 extends StatelessWidget {
  final OverlayBuilder overlayBuilder;
  MyOverlayWidget2({@required this.overlayBuilder});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          overlayBuilder.hide();
        },
        child: Container(
          height: 100,
          width: 100,
          color: Colors.orange,
        ));
  }
}
