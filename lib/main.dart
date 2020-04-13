import 'package:flutter/material.dart';
import 'services/authHandler.dart';
import 'pages/WaitScreen.dart';
import 'pages/signIn.dart';
void main() => runApp(new MaterialApp(
      // home: new RoomCreatingScreen(),
      home: new AuthHandler(),
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
      print('inactive');
      break;
      case AppLifecycleState.paused:
      print('paused');
      break;
      case AppLifecycleState.resumed:
      print('resumed');
      break;
      case AppLifecycleState.detached:
      print('detached');
      break;

    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthHandler();
  }
}
