import 'package:cs4990_app/favorites.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class openingPage extends StatefulWidget {
  openingPage({Key key}) : super(key: key);
  @override
  _openingState createState() => _openingState();
}

class _openingState extends State<openingPage> {


  var emailController = TextEditingController();
  var passController = TextEditingController();

  var currentUser = "Unknown";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        body: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Welcome, $currentUser"),
        Text("E-mail: "),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'E-mail',
          ),
        ),
        Text("Password: "),
        TextField(
          controller: passController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        FlatButton(
          child: Text("Login"),
          onPressed: () {
            print("Pressed1.");
              _auth.signInWithEmailAndPassword(
                  email: emailController.text.toString(),
                  password: passController.text.toString())
                  .then((value){
                print("Successful! " + value.user.uid);
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => FavoritesPage(uid: value.user.uid)),);
                //Navigator.of(context).pushNamed('/FavoritesPage', arguments: value.user.uid);
              }).catchError((e){
                print("Failed to sign up! " + e.toString());
              });


          },
        ),
        FlatButton(
          child: Text("Sign Up"),
          onPressed: () {
            print("Pressed2.");
            _auth.createUserWithEmailAndPassword(
                email: emailController.text.toString(),
                password: passController.text.toString())
                .then((value){
              print("Successful!");
            }).catchError((e){
              print("Failed to sign up! " + e.toString());
            });
          },
        ),
      ],
    ));
  }
}
