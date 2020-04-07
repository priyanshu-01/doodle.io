import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectRoom.dart';
String enteredName;
class EnterName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center
      (child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
              

              onChanged: (str){
               enteredName =str;
                //git = str;
              },
              decoration: new InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 10.0,style: BorderStyle.solid,
                      color: Colors.white
                      )),
                      //fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person, color: Colors.red[800],),
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


                  Padding(padding: EdgeInsets.all(8.0),
                  child: RaisedButton(onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectRoom(userName: enteredName)));
                            
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Play',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 35.0),),
                          ),
                          color: Colors.red[800],),
                  )
          ],
        ),
      )),
      
    );
  }
}