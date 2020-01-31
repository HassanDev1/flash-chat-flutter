import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag:"logo",
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Enter your Email"
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Enter your Password"
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
         RoundedButton(
              title: "Log in",
              onPressed:  () async{
            //implement login functionality;
            try{
            final user = await _auth.signInWithEmailAndPassword(email: email,password: password);
            if(user != null){
              Navigator.pushNamed(context, ChatScreen.id);
            }
            }
            catch(e){
              print(e);
            }
          },
          colour: Colors.lightBlueAccent ,
            ),
          ],
        ),
      ),
    );
  }
}
