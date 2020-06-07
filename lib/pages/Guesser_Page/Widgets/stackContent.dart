
import 'package:flutter/material.dart';
import 'package:scribbl/pages/room/room.dart';
import '../guesserScreen.dart';
import 'animatedAvatar.dart';
class StackContent extends StatelessWidget {
  String position;
  StackContent({this.position});
  @override
  Widget build(BuildContext context) {
    return Container(
    height: position == 'guesser' ? guessCanvasLength : denCanvasLength,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.topCenter,
          height: position == 'guesser'
              ? guessCanvasLength - 15
              : denCanvasLength - 15,
          width: 50.0,
          child: Container(
            height: checkLeftSideContainerHeight(position),
            child: ListView.builder(
              reverse: false,
              itemCount: playersId.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: (guessersId.indexOf(playersId[index]) == -1)
                        ? (denId == playersId[index])
                            ? CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 18.5,
                                  backgroundImage: NetworkImage(playersImage[
                                      // playersId.indexOf(guessersId[index])
                                      index]),
                                  backgroundColor: Colors.grey[100],
                                ),
                              )
                            : CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.grey[100],
                                backgroundImage: NetworkImage(playersImage[
                                    // playersId.indexOf(guessersId[index])
                                    index]),
                              )
                        : CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.green[600],
                            child: CircleAvatar(
                              radius: 18.5,
                              backgroundImage: NetworkImage(playersImage[
                                  // playersId.indexOf(guessersId[index])
                                  index]),
                              backgroundColor: Colors.grey[100],
                            ),
                          ));
              },
            ),
          ),
        ),
        position == 'guesser'
            ? AnimatedAvatar()
            : Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey[100],
                    backgroundImage:
                        NetworkImage(playersImage[playersId.indexOf(denId)]),
                  ),
                ),
              )
      ],
    ),
  );
  }
double checkLeftSideContainerHeight(String position) {
  double tempHeight;
  int len;
  (position == 'guesser')
      ? tempHeight = guessCanvasLength - 15
      : tempHeight = denCanvasLength - 15;
  int i = (tempHeight ~/ 50);
  if (i < playersId.length)
    len = i * 50;
  else
    len = playersId.length * 50;
  return len.toDouble();
}


}
