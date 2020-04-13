import 'package:flutter/material.dart';
import 'room.dart';
class WordWas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 400.0,
      child: Center(
        child: Text('The word was $word'),
      ),
    );
  }
}