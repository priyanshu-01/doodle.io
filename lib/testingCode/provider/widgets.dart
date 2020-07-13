import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/testingCode/provider/ProviderWorking.dart';

class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var proData = Provider.of<ProviderData>(context);
    print('red rebuilding');

    return GestureDetector(
      onTap: () => proData.increaseCounter(),
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.red,
        child: Center(child: Text(proData.counter.toString())),
      ),
    );
  }
}

class Widget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var proData = Provider.of<ProviderData>(context);
    print('green rebuilding');
    return GestureDetector(
      onTap: () => proData.increaseCounter(),
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.green,
        child: Center(child: Text(proData.counter.toString())),
      ),
    );
  }
}

class Widget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var proData = Provider.of<ProviderData>(context);
    print('blue rebuilding');

    return GestureDetector(
      onTap: () => proData.increaseCounter(),
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.blue,
        child: Center(child: Text(proData.counter.toString())),
      ),
    );
  }
}
