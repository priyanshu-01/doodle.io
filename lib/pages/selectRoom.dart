import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/authService.dart';
import '../services/authHandler.dart';
import 'roomId.dart';
import 'room.dart';
import 'dart:math';
import 'roomCreatingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'guesserScreen.dart';
import '../services/anon.dart';
import 'loginPage.dart';
 double effectiveLength=0;
String userNam;
String identity;
int id;
bool initialiseDimension=true;
class SelectRoom extends StatefulWidget {
  String userName;
  SelectRoom({Key key, this.userName}):super(key:key);
  @override
  _SelectRoomState createState() => _SelectRoomState(userName);
}
class _SelectRoomState extends State<SelectRoom> {
Widget showDrawer(){
  return                 Row(
                  children: <Widget>[
                    (check==signInMethod.google)?
                    InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0,
                                            top: 8.0),
                                            child: CircleAvatar(    
                                              backgroundColor: Colors.orange,   
                        backgroundImage: NetworkImage(imageUrl,),
                        radius: 25.0,
                      ),
                                          ),
                      onTap: () {
                         _scaffoldKey.currentState.openDrawer();
                      },
                    )
                    :
                    IconButton(
                      color: Colors.red[800],
                      icon: Icon(Icons.menu),
                      onPressed: (){
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                        Icon(Icons.attach_money),
                        Text(coins.toString(), style: TextStyle(fontSize: 20.0),)
                      ],),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                );
}
  String userName;
  _SelectRoomState(this.userName);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    print('selectRoom called');
    if(initialiseDimension){
         effectiveLength= MediaQuery.of(context).size.height;
      guessTotalLength= MediaQuery.of(context).size.height;
    print('Total length '+'$guessTotalLength');
    guessCanvasLength= ((effectiveLength-70)*0.6)*(7/8);
    print('Canvas Length $guessCanvasLength');
    initialiseDimension=false;
    }
   
    userNam = userName;
    if(userNam.indexOf(' ')==-1)
    {userNam='$userNam ';}
    String first = userNam.substring(0,userNam.indexOf(' ')+1);
    // String first = userNam;
    userNam= first;
    return Scaffold(
      key: _scaffoldKey,
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.orange[100]
                  ),
              accountName: Text(name,style: TextStyle(color: Colors.black),),
              accountEmail: Text(email,style: TextStyle(color: Colors.black),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(height: 50.0,),
                ListTile(

                          onTap: (){
                            //FirebaseAuth.instance.currentUser().
                              (check==signInMethod.google)?AuthProvider().signOutGoogle():signOut();
                          },
                          
                          title: Text('Sign Out'),
                          leading: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
          body: Container(
            
            decoration: new BoxDecoration(
               color: Colors.orange[50],
              image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.dstATop),
            image: new AssetImage('assets/images/selectRoom.jpg')
          ),
          ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0,),
                showDrawer(),
                SizedBox(height: 40.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left : 20.0, right :20.0),
                    child: Card(
                      elevation: 10.0,
                      //color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      borderOnForeground: true,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: <Widget>[
                             SizedBox(height: 20.0,),
                             Row(
                               children: <Widget>[
                                 SizedBox(width: 20.0,),
                                 Text("Let's Play", style:GoogleFonts.roboto(fontSize: 24.0,fontWeight: FontWeight.bold),),
                               ],
                             ),
                             Divider(color: Colors.indigo[700],
                             indent: 60.0,
                             endIndent: 20.0,
                             thickness: 2.0,
                             height: 30.0,
                             ),
                           SizedBox(height: 10.0,),
                                     Row(

                      children: <Widget>[
                        SizedBox(width: 20.0,),
                        Flexible(
                           child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: 
                            //Text('You have 90 seconds to make it happen. All the Best!', style: TextStyle(color: Colors.grey),softWrap: true,)
                            Text('Connect with your friends to start Doodling. All the Best!', style: TextStyle(color: Colors.grey),softWrap: true,)
                            ),
                        ),
                      ],
                    ),
                           SizedBox(height: 20.0,),
                           Padding(
                             padding: const EdgeInsets.all(18.0),
                             child: RaisedButton(onPressed: () {

                               Navigator.push(context, MaterialPageRoute(builder: (context) => RoomCreatingScreen(
                               )) );

                               Random random = Random();
                                 double randomNumber;
                               
                               randomNumber = random.nextDouble();
                               double d= randomNumber*1000000;
                               id= d.toInt();
                                print(id);


                              addRoom();
                              //  Firestore.instance.runTransaction((transaction) async{
                              //  CollectionReference rooms= Firestore.instance.collection('rooms');
                              //  await rooms.add({
                              //  'id': id,'game':false,
                              //  'counter':0, 'guesses':0,
                              //  'users': [], 'users_id': [],
                              //  'tempScore':[],'finalScore':[],
                              //  'host':userNam,'host_id':0,
                              //  'den':userNam, 'den_id':0,
                              //  'round':1,
                              //  'length':0,'xpos':{},'ypos':{},
                              //  'word':'*','wordChosen':false,
                              //  'chat':[], 
                              //  'indices': [0], 'pointer': 0, 
                              //  });

                              //    }).catchError((e){
                              //      print(e);
                              //    });
                                 
                                   Navigator.pop(context);

                                 Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRoom(
                                 id: id
                               )) );
                             
                               
                             },
                             shape: RoundedRectangleBorder(
                             
                             borderRadius: BorderRadius.circular(18.0),
                             
                             ),
                             
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 20.0),
                               child: Text('Create Room',style: GoogleFonts.notoSans(color: Color(0xFF00008B),
                               fontSize: 20.0)),
                             ),
                             color: Colors.orange[300],
                             ),
                           ),
                           SizedBox(height: 10.0,),
                           Padding(
                             padding: const EdgeInsets.all(18.0),
                             child: RaisedButton(onPressed: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => EnterRoomId()) );
                               
                             },
                             shape: RoundedRectangleBorder(
                               side: BorderSide(color: Colors.orange[400],width: 2.0),
                             borderRadius: BorderRadius.circular(18.0)),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical:18.0, horizontal: 30.0),
                               child: Text('Join Room',style: GoogleFonts.notoSans(color: Colors.orange[700],
                               fontSize: 20.0),),
                             ),
                             color: Colors.white
                             ),
                           ),
                           SizedBox(height: 20.0,),

                         ],),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
Future<void> addRoom()async {
  await Firestore.instance.collection('rooms').add({
                               'id': id,'game':false,
                               'counter':0, 'guesses':0,
                               'users': [], 'users_id': [],
                               'tempScore':[],'finalScore':[],
                               'host':userNam,'host_id':0,
                               'den':userNam, 'den_id':0,
                               'round':1,
                               'length':0,'xpos':{},'ypos':{},
                               'word':'*','wordChosen':false,
                               'chat':[], 
                               'indices': [0], 'pointer': 0, 
                               'numberOfRounds': 3,
                               });
}
