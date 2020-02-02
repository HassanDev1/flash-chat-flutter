import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/message_builder.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
FirebaseUser loggedInUser;
final firestore = Firestore.instance;

 
 
class ChatScreen extends StatefulWidget {
 static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  
   String text;
  final  messageTextController =  TextEditingController();
  final _auth = FirebaseAuth.instance;
  
  
  @override
  void initState() {
    
    super.initState();
    getCurrentUser();
    
  }
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                      //Implement send functionality.
                      try{
                      await firestore.collection("messages").add({
                        'text':text,
                        'user':loggedInUser.email,});
                        messageTextController.clear();
                      }
                      
                      catch(e){
                        print(e);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}