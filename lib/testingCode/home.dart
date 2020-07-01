import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/testingCode/data.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataHolder(),
      child: Scaffold(
        body: Container(
          child: Column(
            children: [Listener1(), Listener2(), NonListener()],
          ),
        ),
        floatingActionButton: MyFloatingActionButton(),
      ),
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataHolder = Provider.of<DataHolder>(context);
    return FloatingActionButton(
      onPressed: () {
        (dataHolder.color1 == Colors.blue)
            ? dataHolder.myColor1 = Colors.red
            : dataHolder.myColor1 = Colors.blue;
        (dataHolder.color2 == Colors.blue)
            ? dataHolder.myColor2 = Colors.red
            : dataHolder.myColor2 = Colors.blue;
      },
    );
  }
}

class Listener1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataHolder = Provider.of<DataHolder>(context);
    print('listener1 rebuilt');

    return Container(
        child: Column(
          children: [
            ChildListener1(),
          ],
        ),
        height: 200,
        width: 300.0,
        color: Colors.purple
        //  dataHolder.color1,
        );
  }
}

class ChildListener1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var dataHolder = Provider.of<DataHolder>(context);
    print('listener1 child rebuilt');

    return Container(
      width: 50.0,
      color: Colors.pink,
      height: 50.0,
    );
  }
}

class Listener2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('listener2 rebuilt');
    var dataHolder = Provider.of<DataHolder>(context);

    return Container(
      height: 200,
      color: dataHolder.color2,
    );
  }
}

class NonListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataHolder = Provider.of<DataHolder>(context);

    print('non listener');
    return Container(
      color: Colors.green,
      height: 200.0,
    );
  }
}
