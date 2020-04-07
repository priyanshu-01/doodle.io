import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/roomCreatingScreen.dart';
import 'package:scribbl/pages/timer.dart';
import 'selectRoom.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'gameScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
bool game;
String host;
int flag=0;
int counter ;
List players= new List();
int roomID;
String denner;
String word;
var a;
var chat;

String documentid;
          
class CreateRoom extends StatelessWidget {
          int id;
          int count;
          List play = new List();
          CreateRoom({Key key, this.id}):super(key:key);
          // @override
          // void dispose(){
          //   removeMe(players, counter);
          //   super.dispose();
          // }

         @override
        Widget build(BuildContext context) {
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
             if(flag==0)
              { 
                print(players);
                play = players+[userNam];
                print(play);
                count = counter+1;
                print(count);
                Firestore.instance.collection('rooms').document(documentid).updateData({'users':play});
                Firestore.instance.collection('rooms').document(documentid).updateData({'counter':(count)});
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
            
            if(host!=userNam){
              Navigator.pop(context);
            }
            Navigator.pop(context);
            removeMe(players, counter);
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
  Future<void> removeMe(List a, int b) async{
  
    List playerRemoved = new List();
    int count= b-1;
    playerRemoved =a;
    playerRemoved.remove(userNam);
    print(playerRemoved);


       await Firestore.instance.collection('rooms').document(documentid).updateData({'users':playerRemoved,
       'counter':count});

       if(playerRemoved.length==0){
        // del doc
         await Firestore.instance.collection('rooms').document(documentid).delete().catchError((e){
           print(e);
           print('its an error');
         });
       }
       else{
         if(host==userNam){
                  await Firestore.instance.collection('rooms').document(documentid).updateData({'host':(playerRemoved.length==0?'':playerRemoved[0])  });
                }
                if(denner==userNam){
                  changeDen();
                }

       }
       flag=0;
       
                  
  }

  Future<void> startGame()async{
    await Firestore.instance.collection('rooms').document(documentid).updateData({'game':true});
  }
  

}