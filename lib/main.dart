import 'package:flutter/material.dart';
import 'services/authHandler.dart';
import 'package:screen/screen.dart';
bool resumed=true;
void main() => runApp(new MaterialApp(
      // home: new RoomCreatingScreen(),
      home: new MyHomePage(),
      //home: SignIn(),
      debugShowCheckedModeBanner: false,
     theme: ThemeData(primarySwatch: Colors.red),
    ));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose(){
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print('state= $state');
    switch (state){
      case AppLifecycleState.inactive:
      {
        print('inactive');
        resumed=false;
      }
      break;
      case AppLifecycleState.paused:
      {
        print('paused');
        resumed=false;
      }
      break;
      case AppLifecycleState.resumed:
      {
        print('resumed');
        resumed=true;
      }
      break;
      case AppLifecycleState.detached:
      {
        print('detached');
        resumed=false;
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return AuthHandler();
    //return Wid1();

  }
}
