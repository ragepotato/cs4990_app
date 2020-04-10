import 'package:cs4990_app/favorites.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String signinError = "";
  var currentUser = "Unknown";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 76, 187, 204),
        body: Builder(builder: (context) {
          return


            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "SeeNext",
                        style: GoogleFonts.lobster(fontSize: 75.0),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "E-mail: ",
                            style: GoogleFonts.ubuntu(),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 30),
                            width: 320,
                            child: TextField(
                              style: GoogleFonts.ubuntu(),
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'E-mail',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Password: ",
                            style: GoogleFonts.ubuntu(),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 30),
                            width: 320,
                            child: TextField(
                              style: GoogleFonts.ubuntu(),
                              controller: passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(7),
                        child: Wrap(children: <Widget>[
                          Text(
                            signinError,
                            style: GoogleFonts.ubuntu(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),

                        ],),
                      ),
                      RaisedButton(
                        child: Text("Sign-In"),
                        onPressed: () {
                          print("Pressed1.");
                          _auth
                              .signInWithEmailAndPassword(
                                  email: emailController.text.toString(),
                                  password: passController.text.toString())
                              .then((value) {
                            print("Successful! " + value.user.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyHomePage(uid: value.user.uid)),
                            );
                          }).catchError((e) {
                            print("Failed to Login! " + e.toString());
                            setState(() {
                              signinError = e
                                  .toString()
                                  .replaceAll("PlatformException", "");
                            });
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text("Don't have an account? Sign Up"),
                        onPressed: () {
                          createAccountDialog(context).then((onValue) {
                            if (onValue == "Success") {
                              //  SnackBar movieBar =

                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: new Text("Success! Account created."),
                              ));
                            }

                            //
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );

        }));
  }

  Future<String> createAccountDialog(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    String errorMessage = " ";
    var axisSize = MainAxisSize.min;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //contentPadding: EdgeInsets.all(5.0),
            title: Text("Create an account", style: GoogleFonts.ubuntu()),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: axisSize,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.only(right: 20),

                      child: TextField(
                        style: GoogleFonts.ubuntu(),
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                      ),
                    ),

                    Text(
                      "",
                    ),

                    Container(
                      child: TextField(
                        style: GoogleFonts.ubuntu(),
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),

                    Container(
                      //height: 10,
                      padding: EdgeInsets.all(5),
                      child: Text(errorMessage,
                          style: GoogleFonts.ubuntu(color: Colors.red)),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("Go Back", style: GoogleFonts.ubuntu()),
                            onPressed: () {
                              Navigator.of(context).pop("nah");
                            }),
                        RaisedButton(
                          child: Text("Create Account",
                              style: GoogleFonts.ubuntu()),
                          onPressed: () {
                            print("Pressed2.");

                            _auth
                                .createUserWithEmailAndPassword(
                                    email: emailController.text.toString(),
                                    password: passController.text.toString())
                                .then((value) {
                              print("Successful!");
                              Navigator.of(context).pop("Success");
                            }).catchError((e) {
                              print("Failed to sign up! " + e.toString());
                              setState(() {
                                errorMessage = e
                                    .toString()
                                    .replaceAll("PlatformException", "");
                                print(errorMessage.replaceAll(
                                    "PlatformException", ""));
                                //axisSize = MainAxisSize.values(MainAxisSize.min);
                              });
                            });
                          },
                        ),
                      ],
                    ),

                    //getGenres(errorMessage),
                  ],
                ),
              );
            }),

            actions: <Widget>[],
          );
        });
  }

//  Widget getGenres(String errorMessage) {
//      if (errorMessage == ""){
//        return new Text("", style: GoogleFonts.ubuntu(fontSize: .01) );
//      }
//      else{
//        return new Text(errorMessage, style: GoogleFonts.ubuntu(),);
//      }
//
//
//
//
//    }

}
