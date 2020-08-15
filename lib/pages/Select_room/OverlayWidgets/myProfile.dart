import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribbl/gift/gift_contents.dart';
import 'package:scribbl/pages/Select_room/OverlayWidgets/editProfile.dart';
import 'package:scribbl/pages/Select_room/selectRoom.dart';
import 'package:scribbl/services/authHandler.dart';
import 'package:scribbl/OverlayManager/informationOverlayBuilder.dart';
import 'package:scribbl/virtualCurrency/virtualCurrency.dart';

class MyProfile extends StatefulWidget {
  final InformationOverlayBuilder overlayBuilder;
  MyProfile({@required this.overlayBuilder});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    String coin = commas(currency.remainingCoins);
    return Container(
        height: totalLength * 0.3,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 27.0,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(
                          imageUrl,
                        ),
                        radius: 25.0,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style: overlayTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              child: coinImage,
                              height: 20.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              coin,
                              style: overlayTextStyle,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  decoration: overlayBoxDecoration,
                  child: InkWell(
                      enableFeedback: false,
                      onTap: () {
                        audioPlayer.playSound('click');
                        widget.overlayBuilder.hide();
                        widget.overlayBuilder.show(context, EditProfile());
                      },
                      child: OverlayButton(label: 'Edit Profile')),
                ),
              )
            ]));
  }
}
