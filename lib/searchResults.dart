import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'searchFilms.dart';

class SearchResultsPage extends StatefulWidget {
  SearchResultsPage({Key key, this.uid, this.listMatches}) : super(key: key);
  List listMatches;
  final String uid;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResultsPage> {
  var theaterMatches = [];

  void initState() {
    super.initState();
    theaterMatches = widget.listMatches;
    print("Number of movies in theaters: " + theaterMatches.length.toString());
  }

  _FavoritesState() {
    //movieGenres.clear();
  }

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text("Hello, $currentUser"),
//
//        ),
        body: new Column(
      children: <Widget>[
        Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: theaterMatches.length,
                separatorBuilder: (BuildContext context, int Index) =>
                    Divider(),
                itemBuilder: (BuildContext ctxt, int Index) {
                  //key: Key(theaterMatches[Index].theaterFilmName()),
                  return Column(
                    children: <Widget>[
                      Text((Index + 1).toString() +
                          '. ' +
                          theaterMatches[Index].theaterFilmName()),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 200,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500" +
                                    theaterMatches[Index].theaterCover()),
                            fit: BoxFit.cover,
                            alignment: FractionalOffset.topCenter,
                          ),
                        ),
                        //color: Colors.lightBlueAccent,
                        child: new ListTile(
                          leading: Icon(Icons.album),
                          title: Text((Index + 1).toString() +
                              '. ' +
                              theaterMatches[Index].theaterFilmName()),
                        ),
                      ),
                      ExpansionTile(
                        title: Text("Get Details"),
                        children: <Widget>[
                          Text(theaterMatches[Index].theaterFilmPlot()),

                        ],
                      ),
                    ],
                  );
                })),
        FlatButton(
            child: Text("Go Back"),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: Text("Home"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                      )));
            }),
      ],
    ));
  }
}
