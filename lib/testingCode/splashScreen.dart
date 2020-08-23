import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/main.dart';
import 'package:scribbl/pages/loading.dart';

class SplashScreen extends StatefulWidget {
  final Key key;
  SplashScreen({this.key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color screenColor;
  bool _switch = false;
  bool _lastSwitch = true;

  @override
  Widget build(BuildContext context) {
    // remoteConfig.fetch(expiration: const Duration(hours: 12));
    return FutureBuilder<RemoteConfig>(
      future: RemoteConfig.instance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null)
          return Loading();
        else {
          // print(snapshot.data.getBool('signout_button_enabled'));
          if (_switch != _lastSwitch)
            performCheck(snapshot).whenComplete(() => setState(() {
                  _switch = _lastSwitch;
                }));
          return Scaffold(
            body: Container(
              color: screenColor,
            ),
          );
        }
      },
    );
    // if (remoteConfig.getString('signout_button_enabled') == "false")
    //   _color = Colors.red;
    // else
    //   _color = Colors.green;
    // return Scaffold(
    //   body: Container(
    //     color: _color,
    //   ),
    // );
  }

  Future<void> performCheck(snapshot) async {
    await snapshot.data.fetch(expiration: Duration(seconds: 1));
    await snapshot.data.activateFetched().then((value) {
      print('changed :$value');
      if (snapshot.data.getBool('signout_button_enabled') == false)
        screenColor = Colors.red;
      else
        screenColor = Colors.green;
    });
  }
}
