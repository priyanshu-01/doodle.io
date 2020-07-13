import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/testingCode/provider/widgets.dart';

ProviderData providerData;
int counter = 0;

class ProviderWorking extends StatefulWidget {
  @override
  _ProviderWorkingState createState() => _ProviderWorkingState();
}

class _ProviderWorkingState extends State<ProviderWorking> {
  @override
  void initState() {
    providerData = ProviderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => providerData,
        ),
        // ChangeNotifierProvider(
        //   create: (context) => painterCountDown,
        // )
      ], child: WidgetChanger()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          counter++;
        }),
      ),
    );
  }
}

class WidgetChanger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (counter % 3 == 0)
      return Widget1();
    else if ((counter) % 3 == 1)
      return Widget2();
    else
      return Widget3();
  }
}

class ProviderData extends ChangeNotifier {
  int counter;
  ProviderData() {
    counter = 0;
  }
  void increaseCounter() {
    counter++;
    notifyListeners();
  }
}
