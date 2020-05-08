import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/signIn.dart';
import 'package:scribbl/services/authHandler.dart';
import 'selectRoom.dart';
import '../services/anon.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
String enteredName = '';
double screenHeight;
DocumentSnapshot av;
bool keyboard=false;
class EnterName extends StatefulWidget {
  @override
  _EnterNameState createState() => _EnterNameState();
}
class _EnterNameState extends State<EnterName> {
  @override
  void initState() { 
    super.initState();
    keyboard = KeyboardVisibility.isVisible;
    KeyboardVisibility.onChange.listen((bool visible) {
      setState(() {
        keyboard = visible;
      });
    });
    getAvatars();
  }
  Future<void> getAvatars() async{
    av = await Firestore.instance
                          .collection('avatars')
                          .document('images')
                          .get().whenComplete(() {
                            setState(() {  });
                          } );
  }
  @override
  Widget build(BuildContext context) {
    if(keyboard)
    screenHeight= MediaQuery.of(context).size.height*0.6;
    else
    screenHeight= MediaQuery.of(context).size.height;
    double x= screenHeight/12;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        alignment: Alignment.center,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          (av!=null)?
                   CarouselSlider.builder(
                    itemCount: av.data['images'].length,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      //aspectRatio: 2.0,
                      viewportFraction: 0.5,
                      height: 2.0*x,
                      scrollDirection: Axis.horizontal,
                      initialPage: 0,
                      onPageChanged: (index, reason) {
                        imageUrl= av.data['images'][index];
                      },
                    ),
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        //  maxRadius: 60.0,
                        radius: 1.0*x,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(
                            av.data['images'][index]),
                      );
                    },
                  ):Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      radius: 0.7*x,
                    ),
                  ),
                  SizedBox(height: x,),
                   Text(
                     'Hey $enteredName !',
                     style: GoogleFonts.roboto(
                         fontSize: 24.0,
                         fontWeight: FontWeight.bold),
                   ),
                   SizedBox(height: x/2,),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 30.0,),
                            Flexible(
                            child: FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Text(
                                  "Don't forget to take a snapshot when your name pops on the leaderboard!",
                                  style: TextStyle(color: Colors.grey),
                                  softWrap: true,
                                ))),
                          ],
                        ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                  style: GoogleFonts.notoSans(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (str) {
                     setState(() {
                        enteredName = str;
                     });
                  },
                  decoration: new InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.purple[200],
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.white,
                        // width: 16.0,style: BorderStyle.solid
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.grey,
                        // width: 16.0,style: BorderStyle.solid
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        width: 2.0,
                        color: Colors.purple[200],
                        // width: 16.0,style: BorderStyle.solid
                      ),
                    ),
                    focusColor: Colors.red[800],
                  )),
            ),
        ],)
        
        
        
        
        
        
        
        
        //  Column(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //     // Column(
        //     //   children: <Widget>[
        //     //     Row(
        //     //       children: <Widget>[
        //     //         Padding(
        //     //           padding: const EdgeInsets.only(left: 25.0),
        //     //           child: Text(
        //     //             'Hey $enteredName !',
        //     //             style: GoogleFonts.roboto(
        //     //                 fontSize: 24.0,
        //     //                 fontWeight: FontWeight.bold),
        //     //           ),
        //     //         ),
        //     //       ],
        //     //     ),
        //     //     SizedBox(
        //     //       height: 10.0,
        //     //     ),
        //     //     Row(
        //     //       children: <Widget>[
        //     //         SizedBox(
        //     //           width: 25.0,
        //     //         ),
        //     //         Flexible(
        //     //             child: FractionallySizedBox(
        //     //                 widthFactor: 0.9,
        //     //                 child: Text(
        //     //                   "Don't forget to take a snapshot when your name pops on the leaderboard!",
        //     //                   style: TextStyle(color: Colors.grey),
        //     //                   softWrap: true,
        //     //                 ))),
        //     //       ],
        //     //     ),
        //     //   ],
        //     // ),
        //     // FutureBuilder<DocumentSnapshot>(
        //     //   future: Firestore.instance
        //     //       .collection('avatars')
        //     //       .document('images')
        //     //       .get(),
        //     //   builder: (context, snapshot) {
        //     //     if (snapshot.connectionState == ConnectionState.waiting)
        //     //       return Container();
        //     //     else
        //     //     imageUrl= snapshot.data['images'][0];
        //     //  Padding(
        //     //           padding: const EdgeInsets.only(left: 25.0),
        //     //           child: Text(
        //     //             'Hey $enteredName !',
        //     //             style: GoogleFonts.roboto(
        //     //                 fontSize: 24.0,
        //     //                 fontWeight: FontWeight.bold),
        //     //           ),
        //     //         ),
            
        //     // Padding(
        //     //   padding: EdgeInsets.all(8.0),
        //     //   child: RaisedButton(
        //     //       onPressed: () async {
        //     //         // Navigator.of(context).pop();
        //     //         await AuthSignIn().signInAnonymously();
        //     //         //Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectRoom(userName: enteredName)));
        //     //       },
        //     //       shape: RoundedRectangleBorder(
        //     //           borderRadius: BorderRadius.circular(18.0)),
        //     //       child: Padding(
        //     //         padding: const EdgeInsets.symmetric(
        //     //             horizontal: 12.0, vertical: 18.0),
        //     //         child: Row(
        //     //           mainAxisAlignment: MainAxisAlignment.center,
        //     //           mainAxisSize: MainAxisSize.min,
        //     //           children: <Widget>[
        //     //             Text(
        //     //               'Continue',
        //     //               style: GoogleFonts.notoSans(
        //     //                 color: Color(0xFF00008B),
        //     //                 fontSize: 20.0,
        //     //               ),
        //     //             ),
        //     //             SizedBox(
        //     //               width: 20.0,
        //     //             ),
        //     //             Icon(
        //     //               Icons.arrow_forward_ios,
        //     //               color: Color(0xFF00008B),
        //     //             )
        //     //           ],
        //     //         ),
        //     //       ),
        //     //       color: Colors.orange[200]
        //     //       //  color: Color(0xFFFAEBD7)
        //     //       //0xFF4BCFFA
        //     //       ),
        //     // )
        //   ],
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
      ,
      floatingActionButton: FloatingActionButton.extended(
                          onPressed: () async {
                    await AuthSignIn().signInAnonymously();
                   },
        backgroundColor: Colors.orange[600], 
       // icon: Icon(Icons.arrow_forward_ios,),
        label: Row(
          children: <Widget>[
            Text('Continue', style:TextStyle(color: Colors.white)),
            Icon(Icons.arrow_forward_ios)
          ],
        )
        
        ),
    );
  }
}
