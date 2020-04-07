import 'package:flutter/material.dart';
import 'package:scribbl/pages/guesser.dart';
import 'package:scribbl/pages/selectRoom.dart';
import 'timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'room.dart';
class GuesserScreen extends StatelessWidget {
  String mess;
  Map<String,String > newMessage;
  Map<String, String> finalMessage = {'':''};
  List senderName= chat.keys.toList();
  List senderMessage =chat.values.toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
            child: Center(
              child: Expanded(
                              child: Container(
                  color: Colors.brown,
                     constraints: BoxConstraints.expand(),
                   child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                         
                         //Time_gusser(),
                         Flexible(child: Guesser(), flex: 2,),
                         Flexible(
                                                  child: Container(
                    // constraints: BoxConstraints.expand(),
                    height: 200.0,
                    width: 150.0,
                    color: Colors.red[50],
                     child : ListView.builder(
                       
                       itemCount: chat.length,
                       itemBuilder: (BuildContext context, int index) {
                           print('pr');
                           String n = senderName[index];
                           String m = senderMessage[index];
                        return Row(children: <Widget>[
                              Text('$n'),
                              Text('$m')
                           ],);
                      },
                     ),

                   ),
                         ),
                   Flexible(
                                      child: Container(
                       color: Colors.grey,
                       height: 30.0,
                       child: Row(
                         children: <Widget>[
                           Container(
                             color: Colors.orange,
                             width: 100.0,
                             child: TextField(
                                keyboardType: TextInputType.text,
                               onChanged: (message) {
                                 mess=message;
                                 
                               },
                               onEditingComplete: () {
                      
                },
                             ),
                           ),
                           IconButton(icon: Icon(Icons.send),
                           onPressed: (){
                             finalMessage={'':''};
                             newMessage ={userNam:mess};
                             finalMessage.addAll(chat);
                             finalMessage.addAll(newMessage);
                             //newMessage = 
                             sendMessage();
                           },
                           )
                         ],
                       ),
                     ),
                   )
                       ],),
                     )
        
      ),
              ),
            ),
          ),
    );
  }

  Future<void> sendMessage() async{
    Firestore.instance.collection('rooms').document(documentid).updateData({'chat':finalMessage});
  }
}