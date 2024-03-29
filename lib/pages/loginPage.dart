// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/authService.dart';
// import 'enterName.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     double cWidth = MediaQuery.of(context).size.width * 0.7;
//     // double c_height= MediaQuery.of(context).size.height*0.3;
//     if (check == signInMethod.anonymous) {
//       return WillPopScope(
//           onWillPop: () {
//             setState(() {
//               check = signInMethod.google;
//             });
//           },
//           child: EnterName());
//     } else
//       return Scaffold(
//         body: Container(
//           // alignment: Alignment.bottomCenter,
//           decoration: new BoxDecoration(
//             //borderRadius: BorderRadius.circular(20.0),
//             //color: Colors.blue[50],
//             image: new DecorationImage(
//                 fit: BoxFit.cover,
//                 colorFilter: new ColorFilter.mode(
//                     Colors.black.withOpacity(0.4), BlendMode.dstATop),
//                 image: new AssetImage('assets/images/back1.jpg')),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//               // Welcome To
//               Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 20.0,
//                   ),
//                   Text('Welcome to',
//                       style: GoogleFonts.specialElite(
//                           fontSize: 17.0, color: Colors.black)),
//                 ],
//               ),
//               Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 20.0,
//                   ),
//                   Text('Doodle Friends',
//                       style: GoogleFonts.specialElite(
//                           fontSize: 35.0, color: Colors.black)),
//                 ],
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.13),
//               Row(
//                 children: <Widget>[
//                   SizedBox(
//                     width: 20.0,
//                   ),
//                   Flexible(
//                     child: FractionallySizedBox(
//                         widthFactor: 0.8,
//                         child: Text(
//                             'Turn your device into canvas & draw while your friends make a guess in real time!',
//                             style: GoogleFonts.notoSans(
//                                 fontSize: 13.0, color: Colors.black))),
//                   ),
//                 ],
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.11),
//               Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.white),
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         topRight: Radius.circular(30.0))),
//                 //constraints: BoxConstraints.expand(),
//                 // alignment: Alignment.center,
//                 height: MediaQuery.of(context).size.height * 0.45,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Row(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(left: 20.0),
//                           child: Text(
//                             'Be Creative.',
//                             style: GoogleFonts.roboto(
//                                 fontSize: 24.0, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 20.0,
//                         ),
//                         Container(
//                             width: cWidth,
//                             child: Text(
//                               'Think out of the box to draw challenging objects.',
//                               style: TextStyle(color: Colors.grey),
//                               softWrap: true,
//                             )),
//                       ],
//                     ),

//                     RaisedButton(
//                       onPressed: () async {
//                         // Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()) );
//                         //showProgress();
//                         bool res = await AuthProvider().signInWithGoogle();
//                         // Navigator.pop(context);
//                         if (!res) print("Error logging in with google");
//                       },
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.0)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 20.0),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               'Sign in with ',
//                               style: GoogleFonts.roboto(
//                                   color: Colors.white, fontSize: 18.0),
//                             ),
//                             Image(
//                               image: AssetImage('assets/images/google.png'),
//                               height: 40.0,
//                             )
//                           ],
//                         ),
//                       ),
//                       color: Colors.black,
//                     ),
//                     // SizedBox(height: 10.0,),
//                     RaisedButton(
//                       onPressed: () {
//                         setState(() {
//                           check = signInMethod.anonymous;
//                         });
//                         //  Navigator.push(context, MaterialPageRoute(builder: (context) => EnterName()) );
//                       },
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.black),
//                           borderRadius: BorderRadius.circular(30.0)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 13.0, horizontal: 30.0),
//                         child: Text(
//                           'Play as Guest',
//                           style: GoogleFonts.roboto(
//                               color: Colors.black, fontSize: 18.0),
//                         ),
//                       ),
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }
