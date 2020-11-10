import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/OverlayManager/necessaryOverlayBuilder.dart';
import 'package:scribbl/main.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/myProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authHandler.dart';
import '../../../OverlayManager/informationOverlayBuilder.dart';
import 'package:cached_network_image/cached_network_image.dart';

String tempImageUrl;
String tempName;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController myController;
  List modAvatarDocumentList;
  double _height, _radius;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    tempImageUrl = imageUrl;
    tempName = name;
    myController = TextEditingController(text: name);
    // (name != null && name != '') ? name : "Enter Name");
    modAvatarDocumentList = avatarDocument.data()['avatarImages']['boys'] +
        avatarDocument.data()['avatarImages']['girls'];

    if (checkSignInMethod == signInMethod.google) {
      modAvatarDocumentList =
          [userFirebaseDocumentMap['originalImageUrl']] + modAvatarDocumentList;
      // avatarDocument.data['images'] = modAvatarDocument;
    }
    _height = totalLength * 0.65;
    if (signInStatus == status.notSignedIn)
      _radius = _height * 2 / ((8 * 2)) - 4.0;
    else
      _radius = _height * 2 / ((9 * 2)) - 4.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: totalWidth * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (signInStatus == status.signedIn)
              ? Flexible(
                  flex: 1,
                  child: InformationCloseButton(),
                )
              : Container(),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CircleAvatar(
                radius: _radius,
                backgroundImage: CachedNetworkImageProvider(
                  tempImageUrl,
                ),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: (signInStatus == status.signedIn) ? Colors.black : null,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
                child: Scrollbar(
                  controller: _scrollController,
                  // isAlwaysShown: true,
                  child: GridView.builder(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: modAvatarDocumentList.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          enableFeedback: false,
                          onTap: () {
                            audioPlayer.playSound('click');
                            setState(() {
                              tempImageUrl =
                                  //  avatarDocument.data['images'][index];
                                  modAvatarDocumentList[index];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: (tempImageUrl ==
                                              // avatarDocument.data['images'][index]
                                              modAvatarDocumentList[index])
                                          ? Colors.yellow[600]
                                          : Colors.black,
                                      width: 2.0),
                                  color: Colors.blue[800]),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Image(
                                  image:
                                      // NetworkImage(
                                      CachedNetworkImageProvider(
                                          // avatarDocument.data['images'][index]
                                          modAvatarDocumentList[index]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: MyTextField(
              controller: myController,
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              // color: Colors.black,
              alignment: Alignment.center,
              child: Text(
                'Note - Your first name represents you',
                style: GoogleFonts.ubuntu(
                  color: Colors.white,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                        // bottomLeft
                        offset: Offset(-0.8, -0.8),
                        color: Colors.black),
                    Shadow(
                        // bottomRight
                        offset: Offset(0.8, -0.8),
                        color: Colors.black),
                    Shadow(
                        // topRight
                        offset: Offset(1.2, 1.6),
                        color: Colors.black),
                    Shadow(
                        // topLeft
                        offset: Offset(-0.8, 0.8),
                        color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [PlayButton()],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  enableFeedback: false,
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onTap: () {
                    audioPlayer.playSound('click');
                    if (userAuthenticationSnapshot != null &&
                        userAuthenticationSnapshot.hasData &&
                        userAuthenticationSnapshot.data != null) {
                      informationOverlayBuilder.hide();
                      informationOverlayBuilder.show(context,
                          MyProfile(overlayBuilder: informationOverlayBuilder));
                    } else {
                      menu = dialogMenu.loginOptions;
                      dialogMenuKey.currentState.setState(() {});
                    }
                  },
                )),
          )
        ],
      ),
    );
  }
}

Future<void> saveChangesToExistingProfile() async {
  String userLoginType = checkSignInMethod
      .toString()
      .substring(checkSignInMethod.toString().indexOf('.') + 1);
  await FirebaseFirestore.instance
      .collection('users $userLoginType')
      .doc(userFirebaseDocumentId) //add id
      .update({'name': name, 'imageUrl': imageUrl}); //add data
}

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  MyTextField({@required this.controller});
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      showCursor: true,
      style: overlayTextStyle,
      cursorColor: Colors.yellow,
      onChanged: (editedText) {
        setState(() {
          tempName = editedText;
        });
      },
      textInputAction: TextInputAction.newline,
      decoration: new InputDecoration(
        hintText: 'Enter Name',
        hintStyle: overlayTextStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 5.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 5.0),
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        enableFeedback: false,
        onTap: () async {
          if (!_loading) {
            if (tempName != null && tempName != "") {
              await analytics.logEvent(name: 'edited_profile', parameters: {
                'signInMethod': signInMethod.anonymous.toString()
              });
              tempName = tempName.trim();
              imageUrl = tempImageUrl;
              name = tempName;
              name = name.trim();
              myUserName = firstName(name);
              audioPlayer.playSound('click');

              if (signInStatus == status.signedIn) {
                saveChangesToExistingProfile();
                circleAvatarKey.currentState.setState(() {});
                informationOverlayBuilder.hide();
                informationOverlayBuilder.show(
                    context,
                    MyProfile(
                      overlayBuilder: informationOverlayBuilder,
                    ));
              } else {
                setState(() {
                  _loading = true;
                  AnonymousAuthentication()
                      .signInAnonymously()
                      .whenComplete(() => _loading = false);
                });
              }
            }
          }
        },
        child: (_loading == false)
            ? OverlayButton(
                label: (signInStatus == status.notSignedIn) ? 'Play' : 'Save',
              )
            : LoggingIn(
                padding: 10.0,
              ));
  }
}

class LoggingIn extends StatelessWidget {
  final String label;
  final double padding;
  final double size;
  LoggingIn({this.label, this.padding, this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: overlayBoxDecoration,
      height: 40.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: padding,
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 20.0,
                duration: Duration(milliseconds: 600),
              )),
          SizedBox(
            width: padding,
          )
        ],
      ),
    );
  }
}
