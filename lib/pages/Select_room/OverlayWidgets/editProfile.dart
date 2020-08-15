import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/OverlayManager/necessaryOverlayBuilder.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/myProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/enterName.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authHandler.dart';
import '../../../OverlayManager/informationOverlayBuilder.dart';

String tempImageUrl;
String tempName;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController myController;
  List modAvatarDocument;
  @override
  void initState() {
    tempImageUrl = imageUrl;
    tempName = name;
    myController = TextEditingController(text: name);
    // (name != null && name != '') ? name : "Enter Name");
    modAvatarDocument = avatarDocument.data['images'];

    if (check == signInMethod.google) {
      modAvatarDocument =
          [userFirebaseDocument['originalImageUrl']] + modAvatarDocument;
      // avatarDocument.data['images'] = modAvatarDocument;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = totalLength * 0.55;
    return Container(
      height: _height,
      width: totalWidth * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 4,
            child: Column(
              children: [
                CircleAvatar(
                  radius: _height * (2 / (7 * 2)),
                  backgroundImage: NetworkImage(
                    tempImageUrl,
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),
          Flexible(
            flex: 5,
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount:
                    // (check == signInMethod.google)
                    //     ? avatarDocument.data['images'].length + 1:
                    // avatarDocument.data['images'].length,
                    modAvatarDocument.length,
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
                            modAvatarDocument[index];
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
                                        modAvatarDocument[index])
                                    ? Colors.yellow[600]
                                    : (userAuthenticationSnapshot != null &&
                                            userAuthenticationSnapshot
                                                .hasData &&
                                            userAuthenticationSnapshot.data !=
                                                null)
                                        ? Colors.blue[800]
                                        : Colors.black,
                                width: 2.0),
                            color: Colors.blue[800]),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image(
                            image: NetworkImage(
                                // avatarDocument.data['images'][index]
                                modAvatarDocument[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Flexible(
            flex: 2,
            child: MyTextField(
              controller: myController,
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    enableFeedback: false,
                    onTap: () {
                      tempName = tempName.trim();
                      imageUrl = tempImageUrl;
                      name = tempName;
                      name = name.trim();
                      myUserName = firstName(name);
                      audioPlayer.playSound('click');
                      if (userAuthenticationSnapshot != null &&
                          userAuthenticationSnapshot.hasData &&
                          userAuthenticationSnapshot.data != null) {
                        saveChangesToExistingProfile();
                        // .whenComplete(() {
                        circleAvatarKey.currentState.setState(() {});
                        informationOverlayBuilder.hide();
                        informationOverlayBuilder.show(
                            context,
                            MyProfile(
                              overlayBuilder: informationOverlayBuilder,
                            ));
                        // }
                      }
                      // );
                      else
                        AnonymousAuthentication().signInAnonymously();
                    },
                    child: OverlayButton(
                      label: 'Save',
                    )),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  enableFeedback: false,
                  icon: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ),
                  onPressed: () {
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> saveChangesToExistingProfile() async {
    String userLoginType =
        check.toString().substring(check.toString().indexOf('.') + 1);
    await Firestore.instance
        .collection('users $userLoginType')
        .document(userFirebaseDocument.documentID) //add id
        .updateData({'name': name, 'imageUrl': imageUrl}); //add data
  }
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
      // onTap: () {
      //   if (widget.controller.text != name) {
      //     setState(() {
      //       widget.controller.text = name;
      //     });
      //   }
      // },
      // name,
      style: overlayTextStyle,
      onChanged: (editedText) {
        setState(() {
          tempName = editedText;
        });
      },
      textInputAction: TextInputAction.newline,

      decoration: new InputDecoration(
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
