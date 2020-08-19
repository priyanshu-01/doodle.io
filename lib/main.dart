import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/signIn.dart';
import 'package:scribbl/testingCode/designLoginOptions.dart';
import 'OverlayManager/informationOverlayBuilder.dart';
import 'OverlayManager/necessaryOverlayBuilder.dart';
import 'pages/Select_room/functions.dart';
import 'services/authHandler.dart';
import 'package:screen/screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'audioPlayer/audioPlayer.dart';
import 'package:flutter/foundation.dart';
import 'pages/Select_room/selectRoom.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'testingCode/animatedList.dart';
import 'testingCode/provider/ProviderWorking.dart';
import 'testingCode/overlay.dart';
import 'package:scribbl/testingCode/databaseManager.dart';
import 'package:scribbl/testingCode/exampleList.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'testingCode/stateTest.dart';
import 'testingCode/home.dart';
import 'pages/wordWas.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
// FirebaseAnalyticsObserver observer =
//     FirebaseAnalyticsObserver(analytics: analytics);
bool resumed = true;
DateTime currentBackPressTime;
// BuildContext necessaryOverlayContext;
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //must
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  await Firebase.initializeApp();
  runZoned(() {
    runApp(new MaterialApp(
      home: MyHomePage(),
      // home: Home(),
      // home: SampleCodePart(),
      // home: Scaffold(body: WordWasContent()),
      // home: AnimatedListSample(),
      // home: AnimatedListExample(),
      // home: ProviderWorking(),
      // home: PushOverlayButton(),
      // home: DatabaseManager(),
      // home: DesignLoginOptions(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    ));
  }, onError: Crashlytics.instance.recordError);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool dataInitialised = false;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    informationOverlayBuilder = InformationOverlayBuilder();
    necessaryOverlayBuilder = NecessaryOverlayBuilder();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      _source = source;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.none:
          online = false;
          break;
        case ConnectivityResult.mobile:
          online = true;
          break;
        case ConnectivityResult.wifi:
          online = true;
      }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialiseWorkingData();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state= $state');
    switch (state) {
      case AppLifecycleState.inactive:
        {
          resumed = false;
        }
        break;
      case AppLifecycleState.paused:
        {
          resumed = false;
        }
        break;
      case AppLifecycleState.resumed:
        {
          resumed = true;
        }
        break;
      case AppLifecycleState.detached:
        {
          resumed = false;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return WillPopScope(
                child: (!dataInitialised) ? Loading() : AuthHandler(),
                onWillPop: () => onWillPop(context));
          },
        ));
  }

  Future<bool> onWillPop(BuildContext context) {
    BuildContext _context;
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      if (informationOverlayBuilder.overlayEntry == null) {
        currentBackPressTime = now;
        _context = (necessaryOverlayBuilder.overlayEntry == null)
            ? context
            : dialogMenuKey.currentContext;
        Scaffold.of(_context).showSnackBar(SnackBar(
          content: Text('Press Back again To exit..'),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ));
      } else {
        informationOverlayBuilder.hide();
      }
      return Future.value(false);
    }
    return Future.value(true);
  }

  initialiseWorkingData() {
    audioPlayer = AudioPlayer();
    audioPlayer.initialiseSounds().whenComplete(() => getAvatars());
  }

  Future<void> getAvatars() async {
    await FirebaseFirestore.instance
        .collection('avatars')
        .doc('avatarImages')
        .get()
        .then((value) {
      setState(() {
        avatarDocument = value;
        dataInitialised = true;
        imageUrl = avatarDocument.data()['avatarImages']['boys'][0];
      });
    });
  }
}
