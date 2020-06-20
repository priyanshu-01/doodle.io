import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'room/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'roomCreatingScreen.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
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


    return 
             Container(
              height: totalLength*0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BeautyTextfield(
                      width: totalWidth*0.7,
                      prefixIcon: Icon(Icons.vpn_key, color: Colors.white,),
                      height: 60.0,
                      inputType: TextInputType.number,
                      placeholder: 'Room ID',
                      margin: EdgeInsets.all(10.0),
                      accentColor: Colors.black,
                      textColor: Colors.white,
                      enabled: true,
                      autofocus: true,
              onChanged: (str){
               enteredId =str;
               setState(() {
                 mistake=false;
               });
              },
              // decoration: new InputDecoration(
              //         labelText: 'Room ID',
              //         labelStyle: TextStyle(color: Colors.white),
              //         disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 10.0,style: BorderStyle.solid,
              //         color: Colors.white
              //         )),
              //         //fillColor: Colors.white,
              //         prefixIcon: Icon(Icons.vpn_key, color: Colors.red[800],),
              //         border: new OutlineInputBorder(

              //           borderRadius: new BorderRadius.circular(25.0),
              //           borderSide: new BorderSide(
              //             color: Colors.white,
              //             // width: 16.0,style: BorderStyle.solid
              //           ),

              //         ),
              //         enabledBorder: OutlineInputBorder(

              //           borderRadius: new BorderRadius.circular(25.0),
              //           borderSide: new BorderSide(
              //             color: Colors.white,
              //             // width: 16.0,style: BorderStyle.solid
              //           ),

              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: new BorderRadius.circular(25.0),
              //           borderSide: new BorderSide(
              //             color: Colors.red[800],
              //             // width: 16.0,style: BorderStyle.solid
              //           ),

              //         ),
              //         focusColor: Colors.red[800],
              //         //filled: true,
                      
              //         errorBorder: OutlineInputBorder(
              //           borderRadius: new BorderRadius.circular(25.0),
              //           borderSide: new BorderSide(
              //             color: Colors.red[800],
              //             // width: 16.0,style: BorderStyle.solid
              //           ),

              //         ),


              // )
            ),
                  ),
                  showWarning(),

                RaisedButton(onPressed: () {
                    flag=false;
                    (enteredId!=null)?
                    val = int.parse(enteredId):val=0;  //error by crashlytics   --got undertesting fix
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
        
      );
    
  }
  Widget showWarning(){
    if(mistake==false){
      return  Container();
    }
    else{
      return Text('It seems you made a mistake, Try Again!',
      style: GoogleFonts.quicksand(color: Colors.black
      ),
      );
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
  }
}
