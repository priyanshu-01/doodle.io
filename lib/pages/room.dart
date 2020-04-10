import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/roomCreatingScreen.dart';
import 'package:scribbl/pages/painterView.dart';
import 'selectRoom.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'gameScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
bool game;
String host;
int flag=0;
int counter ;
List players= new List();
int roomID;
String denner;
String word;
int hostId;
int denId;
List playersId = new List();
var a;
var chat = new List();

String documentid;

void getUserId(){
  
      Random random = Random();
       double randomNumber;  
       randomNumber = random.nextDouble();
      double d= randomNumber*1000000;
      identity= d.toInt();
}
          
class CreateRoom extends StatelessWidget {
          int id;
          int count;
          List play = new List();
          List playId= new List();
          CreateRoom({Key key, this.id}):super(key:key);
         @override
        Widget build(BuildContext context) {
           getUserId();
          flag=0;
          roomID = id;
        return  WillPopScope(

          child: Scaffold(
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('rooms').where('id',isEqualTo: id).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot )
            {              

              if(snapshot.data.documents==[])
              {
                return Text('Please enter a Valid Room ID');
              }
              else{
                documentid= snapshot.data.documents[0].documentID;
              counter = snapshot.data.documents[0]['counter'];
              players = snapshot.data.documents[0]['users'];
              host = snapshot.data.documents[0]['host'];
              game = snapshot.data.documents[0]['game'];
              denner= snapshot.data.documents[0]['den'];
              word= snapshot.data.documents[0]['word'];
              a= snapshot.data.documents[0].data;
              chat= snapshot.data.documents[0]['chat'];
              playersId= snapshot.data.documents[0]['users_id'];
              hostId= snapshot.data.documents[0]['host_id'];
              denId= snapshot.data.documents[0]['den_id'];

             if(flag==0)
              { 
                play = players+[userNam];
                count = counter+1;
                playId= playersId+[identity];

                if(players.length==0){
                    Firestore.instance.collection('rooms')
                .document(documentid)
                .updateData({
                  'host_id': identity,
                  'den_id': identity,
                  });
                }

                Firestore.instance.collection('rooms')
                .document(documentid)
                .updateData({'users':play,
                 'counter':(count),
                  'users_id':playId,
                  });
                flag=1;
                //return RoomCreatingScreen();
              }

              if(game==false)
              return Center(
                child: Container(
                  color: Colors.red[600],
                  child: SafeArea(
                                    child: Container(
                      color: Colors.red[800],
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                                                  child: Padding(
                              padding: const EdgeInsets.fromLTRB(8.0,25.0,8.0,10.0),
                              child: Container(child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('Room id : $id',style: GoogleFonts.quicksand(fontSize: 25.0,
                                    color: Colors.white
                                    ),
                                    
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                    child: Text('Share this with your firends',
                                    style: GoogleFonts.quicksand(color:Colors.white,
                                    ),
                                    
                                    ),
                                  ),
                                  Text(' and ask them to join!',
                                  style: GoogleFonts.quicksand(color:Colors.white,
                                  ))
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0
                                ),
                                borderRadius: BorderRadius.circular(25.0)
                              ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex:3,
                                                  child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Container(

                                color: Colors.white,
                                // decoration: BoxDecoration(
                                //   border: Border.all(color: Colors.white)
                                // ),
                                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                                 //height: 400.0,
                                 child: Padding(
                                   padding: const EdgeInsets.only(top:12.0),
                                   child: ListView.builder(
                                   itemCount: snapshot.data.documents[0]['counter'],
                                   itemBuilder: (BuildContext context, int a){
                                     return Column(
                                       children: <Widget>[
                                        //  ListTile(
                                        //    dense: true,
                                        //    contentPadding: EdgeInsets.only(left: 12.0),
                                        //    leading: Icon(Icons.person,),
                                        //    title: Text(players[a], style: GoogleFonts.quicksand(fontSize: 20.0),),
                                        //  ),
                                        Row(children: <Widget>[
                                          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                          child: Icon(Icons.person),
                                          ),
                                          Text(players[a], style: GoogleFonts.quicksand(fontSize: 20.0),),
                                        ],),
                                         Divider(color: Colors.red[600],
                                         thickness: 2.0,
                                         indent: 60.0,
                                         )
                                       ],
                                     );
                                   }),
                                 ),
                                ),
                              ),
                            ),
                          ),

                          Flexible(child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Waiting for friends to join...',
                              style: GoogleFonts.quicksand(color: Colors.white),
                              ),
                              SpinKitThreeBounce(color:Colors.white,
                              size: 20.0,

                              )
                            ],
                          ),
                          
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                            padding: const EdgeInsets.only(top: 14.0, bottom: 12.0),
                            child: startStatus(),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),

              );

              else return GameScreen();
              }
              


              

        },
        ),
          ),
      
    ),
           onWillPop: ()
           {
             leaveRoomAlert(context, players, counter);
           }
          );
          //funct(id);
      
         
        

  }


  // Future<bool> _onWillPop(BuildContext context) async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => new AlertDialog(
  //       title: new Text('Are you sure?'),
  //       content: new Text('Do you want to exit an App'),
  //       actions: <Widget>[
  //         new FlatButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: new Text('No'),
  //         ),
  //         new FlatButton(
  //           onPressed: () => Navigator.of(context).pop(true),
  //           child: new Text('Yes'),
  //         ),
  //       ],
  //     ),
  //   )) ?? false;
  // }

       Widget startStatus(){
            if(userNam==host)
            return RaisedButton(onPressed: () {
                startGame();

            },
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)),
            child: Padding(
              padding: const EdgeInsets.only(top:18.0,bottom: 18.0),
              child: Text('Start Game',style: GoogleFonts.quicksand(color: Colors.red[600]
              ,fontSize: 35.0)),
            ),
            color: Colors.white,
            );
            else
            return Text('$host will start the Game',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 25.0,
              
            ),
            );

          }



          void leaveRoomAlert(BuildContext context, List players, int counter) {
    Alert(

      context: context,
      type: AlertType.none,
      title: "Leave Room ?",
      style: AlertStyle(
        //backgroundColor: Colors.red[600],
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 200),
          alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Color(0xFF4285F4), fontSize: 20),
          ),
          onPressed: () {

            Navigator.pop(context);
            if(hostId!=identity){
              Navigator.pop(context);
            }
            Navigator.pop(context);
            removeMe(players, counter, playersId);
          },
          color: Colors.white,
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red[800],
        )
      ],
    ).show();
  }
  Future<void> removeMe(List a, int b, List c) async{
    List playerRemoved = new List();
    List identityRemoved= new List();
     playerRemoved =a;
     identityRemoved=c;
    int count= b-1;
    int plInd= c.indexOf(identity);
    playerRemoved.removeAt(plInd);
    identityRemoved.removeAt(plInd);

       await Firestore.instance.collection('rooms').document(documentid).updateData({'users':playerRemoved,
       'counter':count, 'users_id': identityRemoved});
       if(playerRemoved.length==0){
        // del doc
         await Firestore.instance.collection('rooms').document(documentid).delete().catchError((e){
           print(e);
           print('its an error');
         });
       }
       else{
         if(hostId==identity)
         {
                  await Firestore.instance.collection('rooms').document(documentid).updateData({'host':playerRemoved[0], 'host_id':identityRemoved[0] });
         }
        if(denId==identity)
        {
                  changeDen();
        }

       }
       flag=0;
       
                  
  }

  Future<void> startGame()async{
    await Firestore.instance.collection('rooms').document(documentid).updateData({'game':true});
  }
  

}