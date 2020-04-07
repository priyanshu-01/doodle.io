import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selectRoom.dart';
import '../services/buttonBuilder.dart';
import '../services/authService.dart';
class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String enteredName;
  bool _visible = false;

  void showProgress() {
    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  //flex: 3,
                                    child: Image(image: AssetImage('assets/images/sm.png'),
                  height: 200.0,),
                ),
                Flexible(child: Text('Scribble',
                style: GoogleFonts.shadowsIntoLight(
                  fontSize: 70.0,letterSpacing: 3.0,
                ),)),
                Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(

              onChanged: (String str){
                enteredName =str;
                //git = str;
              },
              decoration: new InputDecoration(
                    labelText: 'Your Name Here',
                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 10.0,style: BorderStyle.solid)),
                    fillColor: Colors.black,
                    prefixIcon: Icon(Icons.person),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 16.0,style: BorderStyle.solid
                      ),
                    ),
              )
            ),
            
          ),
          Flexible(
            child: _loginButton(),

          ),
          Visibility(
                visible: _visible,
                child: LinearProgressIndicator(),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 30.0, bottom: 10.0),
                child: FloatingActionButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SelectRoom(userName: enteredName)));
                },
                child: Icon(Icons.arrow_forward_ios),
                
                focusElevation: 100.0,
                highlightElevation: 100.0,
                
                ),
              ),
            ],
          )
              ],
            ),
          ),
          decoration: new BoxDecoration(
            //borderRadius: BorderRadius.circular(20.0),
            //color: Colors.blue[50],
            image: new DecorationImage(
              fit: BoxFit.fitHeight,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.dstATop),
              image: new AssetImage('assets/images/scibb.jpg')
            ),
          ),
        ),
      
      
    );
  }

    Widget _loginButton() {
    return GoogleSignInButton(
      onPressed: () async {
        //showProgress();
        bool res = await AuthProvider().signInWithGoogle();
        if (!res) print("Error logging in with google");
      },
      borderRadius: 20.0,
    );
  }
}
class GoogleSignInButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final VoidCallback onPressed;

  GoogleSignInButton(
      {this.onPressed, this.text = 'Sign in with', this.borderRadius = 3.0});

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: Color(0xFF4285F4),
      borderRadius: borderRadius,
      onPressed: onPressed,
      buttonPadding: 0.0,
      children: <Widget>[
        SizedBox(width: 14.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
          child: Text(
            text,
            style: GoogleFonts.roboto(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 38.0,
            width: 38.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(this.borderRadius),
            ),
            child: Center(
              child: Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 18.0,
                width: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

