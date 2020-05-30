import 'package:flutter/material.dart';
import 'reactionWidget.dart';
class ReactionView{
    BuildContext context;
  Image reaction;
  Image sender;
  double top;
  double bottom;
  double right=20;
  OverlayEntry overlayEntry;
  ReactionView(
    this.context,
    {
    this.reaction,
    this.sender,
    this.right,
    this.bottom,
    this.top,

  });
  
   OverlayEntry buildOverlay(){
    return OverlayEntry(builder: (context) {
        return Stack(
       children: <Widget>[
             Positioned(
           top: top,
           bottom: bottom,
           right: right,
         child: ReactionWidget(reaction:reaction, sender: sender),
       ),]
     );
    },);
   }
 void show(){
   if (overlayEntry == null) {
      overlayEntry = buildOverlay();
   Overlay.of(context).insert(overlayEntry);
 }
}
  void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}