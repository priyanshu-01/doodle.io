import 'package:flutter/material.dart';
class ReactionWidget extends StatefulWidget {
  final Image reaction;
  final Image sender;
  ReactionWidget({this.reaction, this.sender});
  @override
  _ReactionWidgetState createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.reaction
    );
  }
}