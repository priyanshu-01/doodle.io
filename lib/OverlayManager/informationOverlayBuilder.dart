import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/services/authHandler.dart';

class InformationOverlayBuilder {
  OverlayEntry overlayEntry;
  OverlayEntry buildOverlay(Widget myOverlayWidget) {
    return OverlayEntry(
      builder: (context) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () => popHide(),
            child: Stack(children: <Widget>[
              GestureDetector(
                onTap: () {
                  hide();
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
          ),
        );
      },
    );
  }

  void show(BuildContext context, Widget myOverlayWidget) {
    // this.doNotDismiss = doNotDismiss;
    overlayEntry = buildOverlay(myOverlayWidget);
    Overlay.of(context).insert(overlayEntry);
  }

  void hide() {
    // this.doNotDismiss = false;
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Future<bool> popHide() async {
    print('popHide called');
    hide();
    return true;
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
  final double padding;
  final double size;
  OverlayButton({@required this.label, this.padding, this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: overlayBoxDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: padding,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              '$label',
              style: myCoustomOverlayTextStyle(size: size),
            ),
          ),
          SizedBox(
            width: padding,
          )
        ],
      ),
    );
  }
}

class InformationCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      alignment: Alignment.centerRight,
      child: InkWell(
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 30.0,
          ),
          enableFeedback: false,
          onTap: () {
            audioPlayer.playSound('click');
            informationOverlayBuilder.hide();
          }

          // informationOverlayBuilder.hide(),
          ),
    );
  }
}

TextStyle myCoustomOverlayTextStyle({double size}) {
  return overlayTextStyle = GoogleFonts.fredokaOne(
    color: Colors.white,
    fontSize: size,
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
  borderRadius: BorderRadius.circular(12.0),
);
