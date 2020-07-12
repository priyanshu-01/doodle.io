import 'package:flutter/material.dart';
import 'package:scribbl/testingCode/exampleList.dart';
import 'services/authHandler.dart';
import 'package:screen/screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'testingCode/stateTest.dart';
import 'testingCode/home.dart';
import 'dart:async';
import 'pages/wordWas.dart';
import 'package:flutter/widgets.dart';
import 'audioPlayer/audioPlayer.dart';
import 'package:flutter/foundation.dart';
import 'testingCode/animatedList.dart';

bool resumed = true;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(new MaterialApp(
      home: new MyHomePage(),
      // home: Home(),
      // home: SampleCodePart(),
      // home: Scaffold(body: WordWasContent()),
      // home: AnimatedListSample(),
      // home: AnimatedListExample(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
    ));
  }, onError: Crashlytics.instance.recordError);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state= $state');
    switch (state) {
      case AppLifecycleState.inactive:
        {
          print('inactive');
          resumed = false;
        }
        break;
      case AppLifecycleState.paused:
        {
          print('paused');
          resumed = false;
        }
        break;
      case AppLifecycleState.resumed:
        {
          print('resumed');
          resumed = true;
        }
        break;
      case AppLifecycleState.detached:
        {
          print('detached');
          resumed = false;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return AuthHandler();
    // return MyApp();
  }
}
