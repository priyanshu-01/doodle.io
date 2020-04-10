import 'package:flutter/material.dart';
import 'room.dart';
class WordWas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Container(
              child: Text('The word was $word'),
      ),
          ),
    );
  }
}