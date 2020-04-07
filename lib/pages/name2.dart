import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/authService.dart';
import 'enterName.dart';
import 'signIn.dart';
class NamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(
        child: Container(
         // height: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.values[2],

            children: <Widget>[

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                
                Text('D',style: GoogleFonts.quicksand(color:Colors.white, fontSize: 40.0),),
                SizedBox(width: 3.0,),
                SpinKitSpinningCircle(color: Colors.white,size: 35.0,),
                SizedBox(width: 5.0,),
                SpinKitSpinningCircle(color: Colors.white,size: 35.0,),
                SizedBox(width: 3.0,),
                Text('dle.io',style: GoogleFonts.quicksand(color:Colors.white, fontSize: 40.0),),
              ],),
              SizedBox(height: 50.0,),
               Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: RaisedButton(onPressed: () async {
                           // Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()) );
        //showProgress();
        bool res = await AuthProvider().signInWithGoogle();
       // Navigator.pop(context);
        if (!res) print("Error logging in with google");
        
      },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:18.0, horizontal: 15.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Sign in with ',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 25.0),),
                           Image(image: AssetImage('assets/images/google.png'), height: 40.0,)
                              ],
                            ),
                          ),
                          color: Colors.black,),
                        ),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: RaisedButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EnterName()) );

                            
                          },
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Play as Guest',style: GoogleFonts.quicksand(color: Colors.white,
                            fontSize: 25.0),),
                          ),
                          color: Colors.black,),
                        ),
            ],
          ),
        ),
      ),
      
    );
  }
}