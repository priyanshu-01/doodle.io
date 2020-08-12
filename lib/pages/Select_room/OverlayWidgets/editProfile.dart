import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/myProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/pages/enterName.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authHandler.dart';
import '../../../OverlayManager/overlayBuilder.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController myController;

  // String nameAfterEditing;

  @override
  void initState() {
    myController = TextEditingController(text: name);
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
                    imageUrl,
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
                itemCount: avatarDocument.data['images'].length,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    enableFeedback: false,
                    onTap: () {
                      audioPlayer.playSound('click');
                      setState(() {
                        imageUrl = avatarDocument.data['images'][index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.yellow[600], width: 1.5),
                            color: Colors.blue),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Image(
                            image: NetworkImage(
                                avatarDocument.data['images'][index]),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Flexible(
            flex: 2,
            child: TextField(
              controller: myController,
              // name,
              style: overlayTextStyle,
              onChanged: (editedText) {
                setState(() {
                  name = editedText;
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
                      audioPlayer.playSound('click');
                      if (userAuthenticationSnapshot != null &&
                          userAuthenticationSnapshot.hasData &&
                          userAuthenticationSnapshot.data != null)
                        saveChangesToExistingProfile().whenComplete(() {
                          circleAvatarKey.currentState.setState(() {});
                          overlayBuilder.hide();
                          overlayBuilder.show(
                              context,
                              MyProfile(
                                overlayBuilder: overlayBuilder,
                              ));
                        });
                      else
                        AnonymousAuthentication().signInAnonymously();
                    },
                    child: OverlayButton(
                      label: 'Save',
                    )),
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
