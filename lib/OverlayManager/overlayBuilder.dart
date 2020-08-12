import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverlayBuilder {
  OverlayEntry overlayEntry;
  bool doNotDismiss;
  OverlayBuilder() {
    doNotDismiss = false;
  }
  OverlayEntry buildOverlay(Widget myOverlayWidget) {
    return OverlayEntry(
      builder: (context) {
        return Scaffold(
          body: Stack(children: <Widget>[
            GestureDetector(
              onTap: () {
                if (this.doNotDismiss != true) hide();
              },
              child: Opacity(
                opacity: 0.85,
                child: Container(
                  color: Colors.black,
                  constraints: BoxConstraints.expand(),
                ),
              ),
            ),
            Center(
                child: OverlayWidgetContent(
              myOverlayWidget: myOverlayWidget,
            )),
          ]),
        );
      },
    );
  }

  void show(BuildContext context, Widget myOverlayWidget, {bool doNotDismiss}) {
    this.doNotDismiss = doNotDismiss;
    overlayEntry = buildOverlay(myOverlayWidget);
    Overlay.of(context).insert(overlayEntry);
  }

  void hide() {
    this.doNotDismiss = false;
    if (overlayEntry != null) {
      overlayEntry.remove();
    }
  }
}

class OverlayWidgetContent extends StatefulWidget {
  final Widget myOverlayWidget;
  OverlayWidgetContent({this.myOverlayWidget});
  @override
  _OverlayWidgetContentState createState() => _OverlayWidgetContentState();
}

class _OverlayWidgetContentState extends State<OverlayWidgetContent>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  CurvedAnimation curvedAnimation;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    curvedAnimation =
        CurvedAnimation(curve: Curves.easeOutBack, parent: animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: curvedAnimation,
      alignment: Alignment.center,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            color: Colors.blue[600],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.myOverlayWidget,
          )),
    );
  }
}

class OverlayButton extends StatelessWidget {
  final String label;
  OverlayButton({@required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: overlayBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '$label',
          style: overlayTextStyle,
        ),
      ),
    );
  }
}

TextStyle overlayTextStyle = GoogleFonts.fredokaOne(
  color: Colors.white,
  shadows: [
    Shadow(
        // bottomLeft
        offset: Offset(-1.0, -1.0),
        color: Colors.black),
    Shadow(
        // bottomRight
        offset: Offset(1.0, -1.0),
        color: Colors.black),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.8),
        color: Colors.black),
    Shadow(
        // topLeft
        offset: Offset(-1.0, 1.0),
        color: Colors.black),
  ],
);

BoxDecoration overlayBoxDecoration = BoxDecoration(
  color: Colors.yellow[700],
  borderRadius: BorderRadius.circular(15.0),
);
