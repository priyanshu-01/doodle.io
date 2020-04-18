import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/authService.dart';
import '../services/authHandler.dart';
import 'roomId.dart';
import 'room.dart';
import 'dart:math';
import 'roomCreatingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String userNam;
int identity;
class SelectRoom extends StatefulWidget {
  String userName;
  SelectRoom({Key key, this.userName}):super(key:key);
  @override
  _SelectRoomState createState() => _SelectRoomState(userName);
}


class _SelectRoomState extends State<SelectRoom> {
Widget showDrawer(){
  if(name !='  ')
  return                 Row(
                  children: <Widget>[
                    IconButton(
                      color: Colors.red[800],
                      icon: Icon(Icons.menu),
                      onPressed: (){
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ],
                );
    else return Container();
}

  String userName;
  _SelectRoomState(this.userName);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
                  
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(height: 50.0,),
                ListTile(
                          onTap: (){AuthProvider().signOutGoogle();},
                          title: Text('Sign Out'),
                          leading: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          ),
          body: Container(
            decoration: new BoxDecoration(
            //borderRadius: BorderRadius.circular(20.0),
            color: Colors.black,
            // image: new DecorationImage(
            //   fit: BoxFit.fitHeight,
            //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
            //   image: new AssetImage('assets/images/scibb.jpg')
            // ),
          ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0,),
                showDrawer(),
                SizedBox(height: 40.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left : 20.0, right :20.0),
                    child: Container(
                      //height: 475.0,
                      //constraints: BoxConstraints.tight(Size(20.0, 20.0)),
                      
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     width: 2.0
                        
                      //   ),
                      //   borderRadius: BorderRadius.circular(25.0),

                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(height: 20.0,),
                          Text('Hey, $first!',style: GoogleFonts.quicksand(color: Colors.white
                          ,fontSize: 35.0)),
                          Divider(color: Colors.white,
                          indent: 20.0,
                          endIndent: 20.0,
                          thickness: 2.0,
                          height: 30.0,
                          ),
                        SizedBox(height: 60.0,),
                        
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: RaisedButton(onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => RoomCreatingScreen(
                            )) );

                            Random random = Random();
                              double randomNumber;
                            int id;
                            randomNumber = random.nextDouble();
                            double d= randomNumber*1000000;
                            id= d.toInt();
                             print(id);
                            Firestore.instance.runTransaction((transaction) async{
                            CollectionReference rooms= Firestore.instance.collection('rooms');
                            await rooms.add({'id': id,'users': [], 'users_id': [],
                            'counter':0, 'host':userNam, 'game':false,
                            'den':userNam,
                            'length':0,'xpos':{},'ypos':{},
                            'word':'*',
                            'wordChosen':false,
                            'chat':[], 'den_id':0, 'host_id':0
                            });

                              }).whenComplete(()  
                              {
                                Navigator.pop(context);

                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRoom(
                              id: id
                            )) );
                          }
                            
                            );
                          
                            
                          },
                          shape: RoundedRectangleBorder(
                          
                          borderRadius: BorderRadius.circular(18.0),
                          
                          ),
                          
                          child: Padding(
                            padding: const EdgeInsets.only(top:18.0,bottom: 18.0),
                            child: Text('Create Room',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 35.0)),
                          ),
                          color: Colors.red[800],
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: RaisedButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EnterRoomId()) );
                            
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Join Room',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 35.0),),
                          ),
                          color: Colors.red[800],),
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