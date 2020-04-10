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
import 'package:google_fonts/google_fonts.dart';

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
    if (widget.myGenreList.contains("Family")) isFamily = true;
    if (widget.myGenreList.contains("Fantasy")) isFantasy = true;
    if (widget.myGenreList.contains("Horror")) isHorror = true;
    if (widget.myGenreList.contains("History")) isHistory = true;
    if (widget.myGenreList.contains("Musical")) isMusical = true;
    if (widget.myGenreList.contains("Mystery")) isMystery = true;
    if (widget.myGenreList.contains("Romance")) isRomance = true;
    if (widget.myGenreList.contains("Science fiction")) isSciFi = true;
    if (widget.myGenreList.contains("Thriller")) isThriller = true;
    if (widget.myGenreList.contains("War")) isWar = true;
    if (widget.myGenreList.contains("Western")) isWestern = true;
  }

  _GenreSearchState() {
    //setState(() {  });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 187, 204),
      appBar: new AppBar(
        title: new Text("Pick Genres"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text("Action", style: GoogleFonts.ubuntu(fontSize: 18)),
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
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text("Adventure",
                          style: GoogleFonts.ubuntu(fontSize: 18)),
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
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text("Animated", style: GoogleFonts.ubuntu(fontSize: 18)),
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
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Comedy",
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
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
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text("Crime", style: GoogleFonts.ubuntu(fontSize: 18)),
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
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text("Documentary",
                          style: GoogleFonts.ubuntu(fontSize: 18)),
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
                ),
              ],
            ),
          ),
    Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Drama", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Family", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Fantasy", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
            ],
          ),),
    Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Horror", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("History", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Musical", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
            ],
          ),),
    Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Mystery", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Romance", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Science Fiction",
                        style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
            ],
          ),),
    Container(
    padding: EdgeInsets.only(left: 15, right: 15),
    child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Thriller", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("War", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text("Western", style: GoogleFonts.ubuntu(fontSize: 18)),
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
              ),
            ],
          ),),
          RaisedButton(
            //color: Colors.white,
            child: Text("Add Genres", style: GoogleFonts.ubuntu(fontSize: 20)),
            padding: EdgeInsets.all(13),
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
