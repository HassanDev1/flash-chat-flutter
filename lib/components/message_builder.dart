import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message_bubble.dart';
FirebaseUser loggedInUser;

class MessageBuilder extends StatelessWidget {
 final _auth = FirebaseAuth.instance;
  
  void getCurrentUser() async{
    try{
    final user = await _auth.currentUser();
    if(user != null){
      loggedInUser = user;
    }
    }
    catch(e){
      print(e);
    }

  } 
  final firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    getCurrentUser();
   
    
    
  
    return StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("messages").snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),);
                }
                final messages = snapshot.data.documents.reversed;
                List<MessageBubble> textMessageWidgets = [];

                for(var message in messages){
                  final messageText = message.data['text'];
                  final messageUser = message.data['user'];

                  textMessageWidgets.add(MessageBubble(
                    messageText: messageText,
                  userEmail:messageUser,
                  isMe: loggedInUser.email == messageUser,));
              }
              return 
              Expanded(    
                child: ListView(
                    reverse: true,
                    children:textMessageWidgets,
                  ),
              );
              }

            );
  }
}