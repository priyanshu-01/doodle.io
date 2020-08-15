import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/editProfile.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/loginOptions.dart';
import 'informationOverlayBuilder.dart';

enum dialogMenu { loginOptions, editProfile }
var menu = dialogMenu.loginOptions;

GlobalKey dialogMenuKey = GlobalKey();

class NecessaryOverlayBuilder {
  OverlayEntry overlayEntry;
  OverlayEntry buildOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Scaffold(
          body: Stack(children: <Widget>[
            Opacity(
              opacity: 0.85,
              child: Container(
                color: Colors.black,
                constraints: BoxConstraints.expand(),
              ),
            ),
            Center(
                child: NecessaryOverlayWidgetContent(
              myOverlayWidget: LoginDialogBox(
                key: dialogMenuKey,
              ),
            )),
          ]),
        );
      },
    );
  }

  void show(BuildContext context) {
    // this.doNotDismiss = doNotDismiss;
    overlayEntry = buildOverlay();
    Overlay.of(context).insert(overlayEntry);
  }

  void hide() {
    // this.doNotDismiss = false;
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}

class LoginDialogBox extends StatefulWidget {
  final GlobalKey key;
  LoginDialogBox({
    @required this.key,
  }) : super(key: key);
  @override
  _LoginDialogBoxState createState() => _LoginDialogBoxState();
}

class _LoginDialogBoxState extends State<LoginDialogBox> {
  @override
  Widget build(BuildContext context) {
    return (menu == dialogMenu.loginOptions) ? LoginOptions() : EditProfile();
  }
}

class NecessaryOverlayWidgetContent extends StatefulWidget {
  final Widget myOverlayWidget;
  NecessaryOverlayWidgetContent({this.myOverlayWidget});
  @override
  _NecessaryOverlayWidgetContentState createState() =>
      _NecessaryOverlayWidgetContentState();
}

class _NecessaryOverlayWidgetContentState
    extends State<NecessaryOverlayWidgetContent>
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
            // color: Colors.blue[600],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.myOverlayWidget,
          )),
    );
  }
}
