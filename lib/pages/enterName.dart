import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectRoom.dart';
import '../services/anon.dart';
String enteredName='';
String imageIndex='';
class EnterName extends StatefulWidget {
  @override
  _EnterNameState createState() => _EnterNameState();
}
class _EnterNameState extends State<EnterName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: 400.0,
       constraints: BoxConstraints.expand(),
      //color: Colors.white,
       decoration: new BoxDecoration(
          //borderRadius: BorderRadius.circular(20.0),
          //color: Colors.blue[50],
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            image: new AssetImage('assets/images/back1.jpg')
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:28.0),
        child: FractionallySizedBox(
          heightFactor: 0.8,

        //  color: Colors.blue,
          child: Container(
         
            child: Card(
              shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
              borderOnForeground: true,
              
              elevation: 10.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:25.0),
                                child: Text('Hey $enteredName !' , style:GoogleFonts.roboto(fontSize: 24.0,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 25.0,),
                              Flexible(child: FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text("Don't forget to take a snapshot when your name pops on the leaderboard!", style: TextStyle(color: Colors.grey),softWrap: true,))),
                            ],
                          ),
                          ],),
                          Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: TextField(
                            style: GoogleFonts.notoSans(color: Colors.black,),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (str){
                             setState(() {
                               enteredName =str;
                             });
         
                            },
                            decoration: new InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.grey),
     
                            prefixIcon: Icon(Icons.person, color: Colors.purple[200],),
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



                            )
                          ),
                        ),


                        Padding(padding: EdgeInsets.all(8.0),
                        child: RaisedButton(onPressed: () async {
                         // Navigator.of(context).pop();
                          await AuthSignIn().signInAnonymously();
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectRoom(userName: enteredName)));
                                },
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Continue',style: GoogleFonts.notoSans(color: Color(0xFF00008B),
                                      fontSize: 20.0, ),),
                                      SizedBox(width: 20.0,),
                                      Icon(Icons.arrow_forward_ios, color:Color(0xFF00008B),)
                                    ],
                                  ),
                                ),
                                color: Colors.orange[200]
                              //  color: Color(0xFFFAEBD7)
                                //0xFF4BCFFA
                                ),
                        )
                        ],
                      ),
            ),
          ),
        ),
      ),
      ),
      
    );
  }
}