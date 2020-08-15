import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wordData.dart';

class DatabaseManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('update words list'),
            onPressed: () => updateDatabase(),
          ),
        ),
      ),
    );
  }

  Future<void> updateDatabase() async {
    await Firestore.instance
        .collection('words')
        .document('word list')
        .updateData({'list': myPreviousDataList});
  }
}

// List myPreviousDataList = [];
