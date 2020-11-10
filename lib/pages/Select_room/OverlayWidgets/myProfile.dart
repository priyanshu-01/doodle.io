import 'package:cached_network_image/cached_network_image.dart';
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
        height: totalLength * 0.55,
        width: totalWidth * 0.7,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                      // color: Colors.black,
                      child: InformationCloseButton())),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: totalLength * 0.1,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: CachedNetworkImageProvider(
                              imageUrl,
                            ),
                            radius: totalLength * 0.1 - 2.0,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$name',
                              style: overlayTextStyle,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.0,
                                ),
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
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  // color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: overlayBoxDecoration,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            audioPlayer.playSound('click');
                            widget.overlayBuilder.hide();
                            widget.overlayBuilder.show(context, EditProfile());
                          },
                          child:
                              // OverlayButton(label: 'Edit Profile')
                              Container(
                            decoration: overlayBoxDecoration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: overlayTextStyle,
                                  ),
                                  SizedBox(
                                    width: 7.0,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 23.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }
}
