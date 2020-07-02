import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/audioPlayer/audioPlayer.dart';
import 'package:scribbl/services/authHandler.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'package:scribbl/virtualCurrency/virtualCurrency.dart';
import '../services/authService.dart';
// import '../services/authHandler.dart';
import 'roomId.dart';
import 'room/room.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'Guesser_screen/guesserScreen.dart';
import '../services/anon.dart';
import 'loginPage.dart';
import '../main.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import '../reactions/listenReactions.dart';
import 'package:spring_button/spring_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';

AudioPlayer audioPlayer;

ReactionListener reactionListener;
double effectiveLength = 0;
String userNam;
String identity;
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

class SelectRoom extends StatefulWidget {
  final String userName;
  final Currency currency;
  final String uid;
  final String name;
  final String imageUrl;
  final String email;
  SelectRoom(
      {Key key,
      @required this.userName,
      @required this.currency,
      @required this.uid,
      @required this.imageUrl,
      @required this.name,
      @required this.email})
      : super(key: key);
  @override
  _SelectRoomState createState() => _SelectRoomState(userName);
}

class _SelectRoomState extends State<SelectRoom> {
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  String userName;
  _SelectRoomState(this.userName);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    resumed = true;
    if (initialiseDimension) {
      effectiveLength = MediaQuery.of(context).size.height;
      totalLength = MediaQuery.of(context).size.height;
      guessCanvasLength = ((effectiveLength - 50) * 0.6) * (7 / 8);
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
    return ChangeNotifierProvider(
      create: (context) => widget.currency,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerContent(
          imageUrl: widget.imageUrl,
          name: widget.name,
          email: widget.email,
        ),
        body: Container(
          decoration: new BoxDecoration(
            color: color['bg'],
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 2,
                child: ShowDrawer(
                  imageUrl: widget.imageUrl,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 16,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
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
                          onTap: () => onPressedCreateRoom(widget.currency),
                          useCache: true,
                          scaleCoefficient: 0.80,
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
                          scaleCoefficient: 0.80,
                          onTap: () => onPressedJoinRoom(context, currency),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedCreateRoom(Currency currency) async {
    await audioPlayer.playSound(audioPlayer.soundTracks['click']);
    flag = false;
    Random random = Random();
    double randomNumber;
    randomNumber = random.nextDouble();
    double d = randomNumber * 1000000;
    id = d.toInt();
    print(id);
    addRoom(widget.uid);
    // Navigator.pop(context);
    Timer(Duration(milliseconds: 150), () {
      Navigator.push(context, createRoute(id, currency)
          // MaterialPageRoute(
          //     builder: (context) => CreateRoom(
          //           id: id,
          //           currency: currency,
          //         ))

          );
    });
  }

  void onPressedJoinRoom(BuildContext context, Currency currency) async {
    await audioPlayer.playSound(audioPlayer.soundTracks['click']);
    Timer(
        Duration(
          milliseconds: 150,
        ), () {
      Alert(
        // desc: 'Enter Room Id',
        context: context,
        content: EnterRoomId(currency: currency),
        buttons: [],
        // image: Image(
        //   image: AssetImage(
        //     'assets/icons/gift.gif',
        //   ),
        //   height: 30.0,
        // )
      ).show();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      audioPlayer = AudioPlayer();
    });

    identity = widget.uid;
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

Route createRoute(int id, Currency currency) {
  CurvedAnimation curvedTransition;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => CreateRoom(
      id: id,
      currency: currency,
    ),
    transitionDuration: Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      curvedTransition =
          CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return ScaleTransition(
        scale: curvedTransition,
        child: child,
      );
    },
  );
}

Future<void> addRoom(String uid) async {
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
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}

class ShowDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String imageUrl;
  ShowDrawer({
    @required this.scaffoldKey,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    // var currency = Provider.of<Currency>(context);
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
            scaffoldKey.currentState.openDrawer();
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
              // Text(
              //   commas(currency.remainingCoins),
              //   style: TextStyle(fontSize: 20.0),
              // )
              VirtualCurrencyContent(
                currency: currency,
              ),
            ],
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class DrawerContent extends StatelessWidget {
  final String name, email, imageUrl;
  DrawerContent({
    @required this.name,
    @required this.imageUrl,
    @required this.email,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
