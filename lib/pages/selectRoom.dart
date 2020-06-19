import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/authService.dart';
import '../services/authHandler.dart';
import 'roomId.dart';
import 'room/room.dart';
import 'dart:math';
import 'roomCreatingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'guesserScreen.dart';
import '../services/anon.dart';
import 'loginPage.dart';
import '../main.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import '../reactions/listenReactions.dart';
import 'package:spring_button/spring_button.dart';

ReactionListener reactionListener;
double effectiveLength = 0;
String userNam;
String identity = uid;
int id;
bool initialiseDimension = true;
bool online;
double totalWidth;
double totalLength;
DocumentSnapshot wordListDocument;

Map<String, Color> color = {
  //'bg2': Color(0xFF2994b2),
  'bg': Color(0xfffffbe0),
  //'buttonBg': Color(0xFF2d4059),
  // 'buttonBg': Color(0xFF120136),
  //'bg2': Color(0xFFfde9c9),
// 'buttonBg': Color(0xFFfcbf1e),
  'buttonBg': Color(0xFFea5455),

  'bg2': Color(0xfffffbe0),
  'buttonText': Color(0xFFea5455),
  'blackShade': Color(0xFF343434)
};

String commas(int n) {
  String c = n.toString();
  String r;
  if (c.length <= 3)
    r = c;
  else if (c.length == 4) {
    r = c.substring(0, 1) + ',' + c.substring(1);
  } else if (c.length == 5) {
    r = c.substring(0, 2) + ',' + c.substring(2);
  } else if (c.length == 6) {
    r = c.substring(0, 1) + ',' + c.substring(1, 3) + ',' + c.substring(3);
  } else if (c.length == 7) {
    r = c.substring(0, 2) + ',' + c.substring(2, 4) + ',' + c.substring(4);
  } else
    r = c;
  return r;
}

class SelectRoom extends StatefulWidget {
  String userName;
  SelectRoom({Key key, this.userName}) : super(key: key);
  @override
  _SelectRoomState createState() => _SelectRoomState(userName);
}

class _SelectRoomState extends State<SelectRoom> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  Widget showDrawer() {
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: CircleAvatar(
              radius: 26.0,
              backgroundColor: color['buttonBg'],
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 25.0,
              ),
            ),
          ),
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.attach_money,
                // color: Colors.yellow,
              ),
              Text(
                commas(coins),
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  String userName;
  _SelectRoomState(this.userName);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    resumed = true;
    print('selectRoom called');
    if (initialiseDimension) {
      effectiveLength = MediaQuery.of(context).size.height;
      totalLength = MediaQuery.of(context).size.height;
      print('Total length ' + '$totalLength');
      guessCanvasLength = ((effectiveLength - 50) * 0.6) * (7 / 8);
      print('Canvas Length $guessCanvasLength');
      totalWidth = MediaQuery.of(context).size.width;
      initialiseDimension = false;
    }
    userNam = userName;
    if (userNam.indexOf(' ') == -1) {
      userNam = '$userNam ';
    }
    String first = userNam.substring(0, userNam.indexOf(' ') + 1);
    userNam = first;
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
    print('connected to internet : $online');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.orange[100]),
                accountName: Text(
                  name,
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  email,
                  style: TextStyle(color: Colors.black),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  backgroundImage: NetworkImage(imageUrl),
                )),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              onTap: () {},
              title: Text('Earn Coins'),
              leading: Icon(Icons.monetization_on),
            ),
            // Divider(
            //   thickness: 1.0,
            // ),
            ListTile(
              onTap: () {},
              title: Text('Developer Contact'),
              leading: Icon(Icons.person_outline),
            ),
            ListTile(
              onTap: () {
                (check == signInMethod.google)
                    ? AuthProvider().signOutGoogle()
                    : signOut();
              },
              title: Text('Sign Out'),
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          //color: Colors.orange[50],
          color: color['bg'],
          // image: new DecorationImage(
          //     fit: BoxFit.cover,
          //     colorFilter: new ColorFilter.mode(
          //         Colors.black.withOpacity(0.10), BlendMode.dstATop),
          //     image: new AssetImage('assets/images/selectRoom.jpg')),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            showDrawer(),
            SizedBox(height: 40.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SpringButton(
                        SpringButtonType.OnlyScale,
                        Container(
                          decoration: BoxDecoration(
                              color: color['buttonBg'],
                              border: Border.all(color: color['buttonBg']),
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 30.0),
                            child: Text('Create Room',
                                style: GoogleFonts.notoSans(
                                    //color: Color(0xFF00008B),
                                    color: color['bg2'],
                                    fontSize: 20.0)),
                          ),
                        ),
                        alignment: Alignment.center,
                        onTap: () => onPressedCreateRoom(),
                        useCache: true,
                        scaleCoefficient: 0.75,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SpringButton(
                        SpringButtonType.OnlyScale,
                        Container(
                          decoration: BoxDecoration(
                              color: color['buttonBg'],
                              border: Border.all(color: color['buttonBg']),
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 40.0),
                            child: Text(
                              'Join Room',
                              style: GoogleFonts.notoSans(
                                  //color: Colors.orange[700],
                                  color: color['bg2'],
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                        scaleCoefficient: 0.75,
                        onTap: () => onPressedJoinRoom(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPressedCreateRoom() {
    flag = false;
    Random random = Random();
    double randomNumber;
    randomNumber = random.nextDouble();
    double d = randomNumber * 1000000;
    id = d.toInt();
    print(id);
    addRoom();
    // Navigator.pop(context);
    Timer(Duration(milliseconds: 500), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateRoom(id: id)));
    });
    // Future.delayed(Duration(milliseconds: 10000));
  }

  void onPressedJoinRoom() {
    Timer(
        Duration(
          milliseconds: 200,
        ), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EnterRoomId()));
    });
  }

  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

Future<void> addRoom() async {
  await Firestore.instance.collection('rooms').add({
    'id': id,
    'game': false,
    'counter': 0,
    'guessersId': [],
    'users': [],
    'users_id': [],
    'usersImage': [],
    'host': userNam,
    'host_id': uid,
    'den': userNam,
    'den_id': uid,
    'numberOfRounds': 3,
    'round': 1,
    'word': '*',
    'wordChosen': false,
    'tempScore': [],
    'finalScore': [],
    'chat': [],
    'indices': [0],
    'pointer': 0,
    'length': 0,
    'xpos': {},
    'ypos': {},
  }).catchError((e) {
    print('error $e');
  });
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
    wordListDocument = await Firestore.instance
        .collection('words')
        .document('word list')
        .get();
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    try {
      controller.sink.add({result: isOnline});
    } catch (Exception) {
      print(Exception);
    }
  }

  void disposeStream() => controller.close();
}
