import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scribbl/OverlayManager/informationOverlayBuilder.dart';
import 'package:scribbl/ProviderManager/manager.dart';
import 'package:scribbl/audioPlayer/audioPlayer.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/myProfile.dart';
import 'package:scribbl/services/authHandler.dart';
import 'package:scribbl/virtualCurrency/data.dart';
import 'package:scribbl/virtualCurrency/virtualCurrency.dart';
import '../../services/authService.dart';
import 'createRoom.dart';
import 'roomId.dart';
import '../room/room.dart';
import 'dart:async';
import '../Guesser_screen/guesserScreen.dart';
import '../../services/anon.dart';
import '../../main.dart';
import '../../reactions/listenReactions.dart';
import 'package:spring_button/spring_button.dart';
import '../../modified_packages/Alert/rflutter_alert.dart';

GlobalKey circleAvatarKey = GlobalKey();
AudioPlayer audioPlayer;
ReactionListener reactionListener;
String myUserName;
String identity;
int id;
bool initialiseDimension = true;
bool online = true;
double totalWidth;
double totalLength;
double keyboardHeight;
List wordList;
double myDenCanvasLength;

Map<String, Color> color = {
  'bg': Color(0xfffffbe0),
  'buttonBg': Colors.yellow[700],
  'bg2': Color(0xfffffbe0),
  'buttonText': Color(0xFFea5455),
  'blackShade': Color(0xFF343434)
};

LinearGradient gradient = LinearGradient(
    colors: [Colors.blue[900], Colors.blue[400]],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter);

String firstName(String myUserName) {
  if (myUserName.indexOf(' ') == -1) {
    myUserName = '$myUserName ';
  }
  myUserName = myUserName.substring(0, myUserName.indexOf(' ') + 1);
  return myUserName;
}

class SelectRoom extends StatefulWidget {
  final Currency currency;
  final String uid;
  final String name;
  final String imageUrl;
  final String email;
  SelectRoom(
      {Key key,
      @required this.currency,
      @required this.uid,
      @required this.imageUrl,
      @required this.name,
      @required this.email})
      : super(key: key);
  @override
  _SelectRoomState createState() => _SelectRoomState();
}

class _SelectRoomState extends State<SelectRoom> {
  bool createRoomPressed = false;
  bool joinRoomPressed = false;
  void performRebuildCalculations() {
    resumed = true;
    if (initialiseDimension) {
      totalLength = MediaQuery.of(context).size.height;
      myDenCanvasLength = (totalLength - 20) * (2 / 3) * (9 / 11);
      denCanvasLength = myDenCanvasLength;
      keyboardHeight = totalLength * 0.3;
      guessCanvasLength = ((totalLength - 50 - 20 - keyboardHeight) * (7 / 8));
      totalWidth = MediaQuery.of(context).size.width;
      initialiseDimension = false;
    }
  }

  @override
  void initState() {
    identity = widget.uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    performRebuildCalculations();
    return ChangeNotifierProvider(
      create: (context) => widget.currency,
      child: SafeArea(
        child: Container(
          decoration: new BoxDecoration(
            gradient: RadialGradient(radius: 1.0, colors: [
              Colors.blue[300],
              Color(0xFF000080),
            ]),
          ),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: TopRowWithAvatarAndCoin(),
              ),
              Flexible(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (remoteConfig.getBool('signout_button_enabled'))
                                ? Expanded(
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        onTap: () {
                                          (checkSignInMethod ==
                                                  signInMethod.google)
                                              ? GoogleAuthentication()
                                                  .signOutGoogle()
                                              : AnonymousAuthentication()
                                                  .signOutAnonymous();
                                        },
                                        child: Container(
                                          child: OverlayButton(label: 'Out'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                            // ShowDrawer(
                            // )
                          ],
                        )),
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SpringButton(
                                    SpringButtonType.OnlyScale,
                                    Container(
                                      decoration: BoxDecoration(
                                          // gradient: gradient,
                                          color: color['buttonBg'],
                                          border: Border.all(
                                              color: color['buttonBg']),
                                          borderRadius:
                                              BorderRadius.circular(18.0)),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 4.0),
                                          child: ButtonToRoom(
                                            buttonTitle: 'CREATE ROOM',
                                          )),
                                    ),
                                    alignment: Alignment.center,
                                    onTap: () => (!createRoomPressed)
                                        ? onPressedCreateRoom(widget.currency)
                                        : null,
                                    useCache: true,
                                    scaleCoefficient: 0.80,
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  SpringButton(
                                    SpringButtonType.OnlyScale,
                                    Container(
                                      decoration: BoxDecoration(
                                          color: color['buttonBg'],
                                          // gradient: gradient,
                                          border: Border.all(
                                              color: color['buttonBg']),
                                          borderRadius:
                                              BorderRadius.circular(18.0)),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 18.0),
                                          child: ButtonToRoom(
                                              buttonTitle: 'JOIN ROOM')),
                                    ),
                                    scaleCoefficient: 0.80,
                                    onTap: () => (!joinRoomPressed)
                                        ? onPressedJoinRoom(context, currency)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Column(
                          children: [Container()],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedCreateRoom(Currency currency) {
    createRoomPressed = true;
    audioPlayer.playSound('click');
    Timer(
        Duration(
          milliseconds: 150,
        ), () {
      Alert(
        style: AlertStyle(backgroundColor: Colors.blue),
        // desc: 'Enter Room Id',
        context: context,
        content: MakeRoom(currency: currency, uid: widget.uid),
        buttons: [],
        // image: Image()
      ).show();
      createRoomPressed = false;
    });
  }

  void onPressedJoinRoom(BuildContext context, Currency currency) {
    joinRoomPressed = true;
    audioPlayer.playSound('click');
    Timer(
        Duration(
          milliseconds: 150,
        ), () {
      Alert(
        // title: "title",
        style: AlertStyle(backgroundColor: Colors.blue),
        // desc: 'Enter Room Id',
        context: context,
        content: EnterRoomId(currency: currency),
        buttons: [],
        // image: Image()
      ).show();
      joinRoomPressed = false;
    });
  }
}

Route createRoute(int id, Currency currency) {
  CurvedAnimation curvedTransition;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Manager(
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

class ButtonToRoom extends StatelessWidget {
  final String buttonTitle;
  ButtonToRoom({@required this.buttonTitle});
  @override
  Widget build(BuildContext context) {
    return Text(
      '$buttonTitle',
      style: GoogleFonts.fredokaOne(
          letterSpacing: 1.5,
          shadows: [
            Shadow(
                // bottomLeft
                offset: Offset(-1.0, -1.0),
                color: Colors.black),
            Shadow(
                // bottomRight
                offset: Offset(1.0, -1.0),
                color: Colors.black),
            Shadow(
                // topRight
                offset: Offset(1.5, 1.8),
                color: Colors.black),
            Shadow(
                // topLeft
                offset: Offset(-1.0, 1.0),
                color: Colors.black),
          ],
          //color: Colors.orange[700],
          color: color['bg2'],
          fontSize: 19.0,
          fontWeight: FontWeight.w600),
    );
  }
}

class TopRowWithAvatarAndCoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var currency = Provider.of<Currency>(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          enableFeedback: false,
          child: Stack(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectRoomAvatar(),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.edit,
                  color: Colors.yellow[700],
                  size: 22.0,
                ),
              )
            ],
          ),
          onTap: () {
            audioPlayer.playSound('click');
            informationOverlayBuilder.show(
                context, MyProfile(overlayBuilder: informationOverlayBuilder));
          },
        ),
        VirtualCurrencyContent(
          currency: currency,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class SelectRoomAvatar extends StatefulWidget {
  SelectRoomAvatar() : super(key: circleAvatarKey);

  @override
  _SelectRoomAvatarState createState() => _SelectRoomAvatarState();
}

class _SelectRoomAvatarState extends State<SelectRoomAvatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26.0,
      backgroundColor: Colors.blue[800],
      child: CircleAvatar(
        backgroundColor: Colors.grey[100],
        backgroundImage: NetworkImage(
          imageUrl,
        ),
        radius: 25.0,
      ),
    );
  }
}

// class DrawerContent extends StatelessWidget {
//   final String name, email, imageUrl;
//   DrawerContent({
//     @required this.name,
//     @required this.imageUrl,
//     @required this.email,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           UserAccountsDrawerHeader(
//               decoration: BoxDecoration(color: Colors.orange[100]),
//               accountName: Text(
//                 name,
//                 style: TextStyle(color: Colors.black),
//               ),
//               accountEmail: Text(
//                 email,
//                 style: TextStyle(color: Colors.black),
//               ),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.grey[100],
//                 backgroundImage: NetworkImage(imageUrl),
//               )),
//           SizedBox(
//             height: 10.0,
//           ),
//           ListTile(
//             onTap: () {},
//             title: Text('Earn Coins'),
//             leading: Icon(Icons.monetization_on),
//           ),
//           ListTile(
//             onTap: () {},
//             title: Text('Developer Contact'),
//             leading: Icon(Icons.person_outline),
//           ),
//           ListTile(
//             onTap: () {
//               (check == signInMethod.google)
//                   ? GoogleAuthentication().signOutGoogle()
//                   : AnonymousAuthentication().signOutAnonymous();
//             },
//             title: Text('Sign Out'),
//             leading: Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//     );
//   }
// }
