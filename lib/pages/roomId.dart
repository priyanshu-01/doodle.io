import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'roomCreatingScreen.dart';
bool mistake = false;
String enteredId;
var details;
class EnterRoomId extends StatefulWidget {
  @override
  _EnterRoomIdState createState() => _EnterRoomIdState();
}

class _EnterRoomIdState extends State<EnterRoomId> {
  int val;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
          body: Center(
            child: Container(
              height: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
              

              onChanged: (str){
               enteredId =str;
               setState(() {
                 mistake=false;
               });
                //git = str;
              },
              onEditingComplete: () {
                
              },
              decoration: new InputDecoration(
                

                      labelText: 'Room ID',
                      labelStyle: TextStyle(color: Colors.white),
                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 10.0,style: BorderStyle.solid,
                      color: Colors.white
                      )),
                      //fillColor: Colors.white,
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.red[800],),
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
                          color: Colors.white,
                          // width: 16.0,style: BorderStyle.solid
                        ),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.red[800],
                          // width: 16.0,style: BorderStyle.solid
                        ),

                      ),
                      focusColor: Colors.red[800],
                      //filled: true,
                      
                      errorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                          color: Colors.red[800],
                          // width: 16.0,style: BorderStyle.solid
                        ),

                      ),


              )
            ),
                  ),
                  ShowWarning(),

                  RaisedButton(onPressed: () {
                            val = int.parse(enteredId);
                            print(val);

                            getDetails(context);    
                            
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Join',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 35.0),),
                          ),
                          color: Colors.red[800],)
                ],
              ),
        
      ),
          ),
    );
  }
  Widget ShowWarning(){
    if(mistake==false){
      return  Container();
    }
    else{
      return Padding(padding: EdgeInsets.all(8.0),
      child: Text('It seems you made a mistake, Try Again!',
      style: GoogleFonts.quicksand(color: Colors.white
      ),
      ));
    }
  }

Future<void> getDetails(BuildContext context) async{
  Navigator.push(context, MaterialPageRoute(builder: (context) => RoomCreatingScreen(
                            )) );
  QuerySnapshot qs;
    var ref = Firestore.instance;
    qs = await ref.collection("rooms").where('id',isEqualTo: val).getDocuments();
    
      if(qs.documents.length!=0){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateRoom(
                              id: val
                            )) );
      }
      else{
        Navigator.pop(context);
        setState(() {
          mistake = true;
        });
        
      }
      
    // setState(() {
      
    // });
  }
}
