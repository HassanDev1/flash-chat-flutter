import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final  messageTextController =  TextEditingController();
  String text;
  final firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  
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
  void getMessages() async{

    await for(var snapshot in firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print(message.data);
      }

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
                getMessages();
                // Navigator.pop(context);
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
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("messages").snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),);
                }
                final messages = snapshot.data.documents;
                List<MessageBubble> textMessageWidgets = [];

                for(var message in messages){
                  final messageText = message.data['text'];
                  final messageUser = message.data['user'];

                  textMessageWidgets.add(MessageBubble(
                    messageText: messageText,
                  userEmail:messageUser));
              }
              return 
              Expanded(    
                child: ListView(
                  
                      children:textMessageWidgets,
                  ),
              );
              }

            ),
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

class MessageBubble extends StatelessWidget {
 MessageBubble({this.messageText,this.userEmail});
 final  String messageText;
  final String userEmail;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Card(
        
        margin: EdgeInsets.only(top:20.0),
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$messageText',
          
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white
          )
          ),
        ),
      ),
      Text('$userEmail')
    ],
    
        ),
      );
  }
}