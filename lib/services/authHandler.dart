import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scribbl/pages/enterName.dart';
import 'package:scribbl/services/anon.dart';
import 'package:scribbl/services/authService.dart';
import '../pages/selectRoom.dart';
import '../pages/signIn.dart';
import '../pages/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String name='  ', email='  ', imageUrl='  ', uid='  ';
int coins;
String dataDocId='  ';
bool anonymous=true;
class AuthHandler extends StatelessWidget  {
  @override
  Widget build(BuildContext context){
    
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot)  {
        
          if (snapshot.connectionState == ConnectionState.waiting)
            return SignIn();//loading page
          else if (snapshot.hasData && snapshot.data != null)
           {
             if(snapshot.data.isAnonymous){
                uid=snapshot.data.uid;
                 getDetailsAnonymous();
                return SelectRoom(userName:name);
                //ano();
             }
             else{
            name = snapshot.data.displayName;
            email = snapshot.data.email;
            imageUrl = snapshot.data.photoUrl;
            uid= snapshot.data.uid;
            getDetailsGoogle();
            return SelectRoom(userName:name);
           // gog();
             }
         //   SelectRoom(userName: 'abcd',);
          } 
          else
            return LoginPage();
        });
  }
}
Future<void> getDetailsAnonymous () async {
  QuerySnapshot doc = await Firestore.instance.collection('users anonymous').where('uid',isEqualTo: uid).getDocuments().catchError((e){
    print('error $e');
  });
   if(doc.documents.length==0){
     name =enteredName;
     coins=1000;
    await AuthSignIn().createAnonymousUser();
    //SelectRoom(userName: name,);
  }
  else{
  DocumentSnapshot  a = doc.documents[0];
  dataDocId= doc.documents[0].documentID;
  coins= a['coins'];
  name = a['name'];
  print('coins $coins');
  await AuthSignIn().activate();
  //return  SelectRoom(userName: name,);
  }
  // var abc = a.data;
  // abc[a];
} 
Future<void> getDetailsGoogle() async{
  QuerySnapshot doc = await Firestore.instance.collection('users google').where('uid',isEqualTo: uid).getDocuments().catchError((e){
    print('error $e');
  });
  if(doc.documents.length==0){
    coins=1000;
    //AuthSignIn().createAnonymousUser();
    await  AuthProvider().createGoogleUser();
     //return SelectRoom(userName: name,);
  }
  else{
  DocumentSnapshot  a = doc.documents[0];
  dataDocId= doc.documents[0].documentID;
  coins= a['coins'];
  print('coins $coins');
  await AuthProvider().activate();
  //return SelectRoom(userName: name,);
  }
  }



  Future<Widget> ano ()async{
       await getDetailsAnonymous();
       return SelectRoom(userName: name,);
  }
   Future<Widget> gog () async{
     await getDetailsGoogle();
       return SelectRoom(userName: name,);
   }