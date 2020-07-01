import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
class SampleCodePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(),
              child: Column(
                children: <Widget>[
                  Flexible(
                      flex: 6,
                      child: SpinKitThreeBounce(color: Colors.blue,)),
                  Flexible(
                    flex:  4,
                    child: FractionallySizedBox(
            heightFactor: 1.0,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey[200]),
                  color: Colors.grey[200]
                  ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListData(),
              ),
            ),
          )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}





class ListData extends StatelessWidget {
  final List chat= ['frames take a lot of time with animation playing','average is 29 ms per frame','problem is with GPU thread','if listview is removed, everyting works fine','frames take a lot of time with animation playing','average is 29 ms per frame','problem is with GPU thread','frames take a lot of time with animation playing','average is 29 ms per frame','problem is with GPU thread','frames take a lot of time with animation playing','average is 29 ms per frame','problem is with GPU thread',];
  final String networkImageUrl='https://firebasestorage.googleapis.com/v0/b/test-b077d.appspot.com/o/avatars%2Favataaars%20(2).png?alt=media&token=44a088a5-b033-49a4-a525-3075d503f9b1';
  @override
  Widget build(BuildContext context) {
    return
     ListView.builder(
      reverse: true,
      itemCount: chat.length,
      itemBuilder: (BuildContext context, int index) {
        String message = chat[index];
        return Container(
          alignment: Alignment.centerRight,
      child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: 
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 2.0),
                  child: Column(
                    children: [
                      Text('Developer'),
                      Text(
                        '$message',
                          style: GoogleFonts.ubuntu(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
               CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.grey[100],
                backgroundImage:
                    NetworkImage(networkImageUrl), 
              )
            ],
          ),
        ),
    );
      },
  );
  }
}