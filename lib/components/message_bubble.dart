import 'package:flutter/material.dart';


class MessageBubble extends StatelessWidget {
 MessageBubble({this.messageText,this.userEmail,this.isMe});
 final  String messageText;
  final String userEmail;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
    crossAxisAlignment: isMe?CrossAxisAlignment.end: CrossAxisAlignment.start,
    children: <Widget>[
      Card(
        margin: EdgeInsets.only(top:20.0),
        color: isMe?Colors.blueAccent:Colors.grey[700],
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