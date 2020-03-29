import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'favorites.dart';
import 'discover.dart';

class GenreSearchPage extends StatefulWidget {
  GenreSearchPage({Key key, this.myGenreList}) : super(key: key);
  final List myGenreList;
  @override
  _GenreSearchState createState() => _GenreSearchState();
}

class _GenreSearchState extends State<GenreSearchPage> {


  final TextEditingController eCtrl = new TextEditingController();

  bool isAction = false;
  bool isAdventure = false;
  bool isAnimated = false;
  bool isComedy = false;
  bool isCrime = false;
  bool isDocumentary = false;
  bool isDrama = false;
  bool isFamily = false;
  bool isFantasy = false;
  bool isHorror = false;
  bool isHistory = false;
  bool isMusical = false;
  bool isMystery = false;
  bool isRomance = false;
  bool isSciFi = false;
  bool isThriller = false;
  bool isWar = false;
  bool isWestern = false;

  void initState() {
    super.initState();
    print("open");
    print(widget.myGenreList);
    if (widget.myGenreList.contains("Action")) isAction = true;
    if (widget.myGenreList.contains("Adventure")) isAdventure = true;
    if (widget.myGenreList.contains("Animated")) isAnimated = true;
    if (widget.myGenreList.contains("Comedy")) isComedy = true;
    if (widget.myGenreList.contains("Crime drama")) isCrime = true;
    if (widget.myGenreList.contains("Documentary")) isDocumentary = true;
    if (widget.myGenreList.contains("Drama")) isDrama = true;
    if (widget.myGenreList.contains("Family")) isFamily= true;
    if (widget.myGenreList.contains("Fantasy")) isFantasy = true;
    if (widget.myGenreList.contains("Horror")) isHorror = true;
    if (widget.myGenreList.contains("History")) isHistory = true;
    if (widget.myGenreList.contains("Musical")) isMusical = true;
    if (widget.myGenreList.contains("Mystery")) isMystery = true;
    if (widget.myGenreList.contains("Romance")) isRomance = true;
    if (widget.myGenreList.contains("Science fiction")) isSciFi = true;
    if (widget.myGenreList.contains("Thriller")) isThriller = true;
    if (widget.myGenreList.contains("War"))  isWar = true;
    if (widget.myGenreList.contains("Western"))  isWestern = true;
  }



  _GenreSearchState() {

    //setState(() {  });



  }
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Hello"),
      ),
      body: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Action"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isAction = changed;
                      });
                    },
                    value: isAction,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Adventure"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isAdventure = changed;
                      });
                    },
                    value: isAdventure,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Animated"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isAnimated = changed;
                      });
                    },
                    value: isAnimated,
                  ),
                ],
              ),
            ],

          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Comedy"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isComedy = changed;
                      });
                    },
                    value: isComedy,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Crime"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isCrime = changed;
                      });
                    },
                    value: isCrime,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Documentary"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isDocumentary = changed;
                      });
                    },
                    value: isDocumentary,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Drama"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isDrama = changed;
                      });
                    },
                    value: isDrama,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Family"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isFamily = changed;
                      });
                    },
                    value: isFamily,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Fantasy"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isFantasy = changed;
                      });
                    },
                    value: isFantasy,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Horror"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isHorror = changed;
                      });
                    },
                    value: isHorror,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("History"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isHistory = changed;
                      });
                    },
                    value: isHistory,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Musical"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isMusical = changed;
                      });
                    },
                    value: isMusical,
                  ),
                ],
              ),
            ],

          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Mystery"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isMystery = changed;
                      });
                    },
                    value: isMystery,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Romance"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isRomance = changed;
                      });
                    },
                    value: isRomance,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Science Fiction"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isSciFi = changed;
                      });
                    },
                    value: isSciFi,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Thriller"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isThriller = changed;
                      });
                    },
                    value: isThriller,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("War"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isWar = changed;
                      });
                    },
                    value: isWar,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Western"),
                  Checkbox(
                    onChanged: (bool changed) {
                      setState(() {
                        isWestern = changed;
                      });
                    },
                    value: isWestern,
                  ),
                ],
              ),
            ],
          ),




          FlatButton(
            color: Colors.white,
            child: Text("ADD GENRES"),
            onPressed: () {
              var pickGenres = [];
              if (isAction) pickGenres.add("Action");
              if (isAdventure) pickGenres.add("Adventure");
              if (isAnimated) pickGenres.add("Animated");
              if (isComedy) pickGenres.add("Comedy");
              if (isCrime) pickGenres.add("Crime drama");
              if (isDocumentary) pickGenres.add("Documentary");
              if (isDrama) pickGenres.add("Drama");
              if (isFamily) pickGenres.add("Family");
              if (isFantasy) pickGenres.add("Fantasy");
              if (isHorror) pickGenres.add("Horror");
              if (isHistory) pickGenres.add("History");
              if (isMusical) pickGenres.add("Musical");
              if (isMystery) pickGenres.add("Mystery");
              if (isRomance) pickGenres.add("Romance");
              if (isSciFi) pickGenres.add("Science fiction");
              if (isThriller) pickGenres.add("Thriller");
              if (isWar) pickGenres.add("War");
              if (isWestern) pickGenres.add("Western");

              print(pickGenres);
              Navigator.pop(context, pickGenres);
            },



          ),
        ],
      ),
    );
  }
}
