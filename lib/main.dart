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


