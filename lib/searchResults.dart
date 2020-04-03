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
import 'package:google_fonts/google_fonts.dart';

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

  Widget getGenreWidgets(List<dynamic> matchGenres, List<dynamic> allGenres) {
    List<Widget> list = new List<Widget>();
    list.add(new Text("Genres: "));
    if (matchGenres != null) {
      print(matchGenres);
      for (var i = 0; i < allGenres.length; i++) {
        if (matchGenres.contains(allGenres[i])) {
          list.add(new Text(allGenres[i],
              style: TextStyle(fontWeight: FontWeight.bold)));
        } else {
          list.add(new Text(allGenres[i]));
        }
      }
      return new Row(children: list);
    }else{
      for(var i = 0; i < allGenres.length; i++){
        list.add(new Text(allGenres[i]));
      }
      return new Row(children: list);
    }

  }

  _FavoritesState() {
    //movieGenres.clear();
  }

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        backgroundColor: Colors.cyanAccent,
//        appBar: new AppBar(
//          title: new Text("Hello, $currentUser"),
//
//        ),
        body: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 7),
              child: Text(
                "RESULTS",
                style: GoogleFonts.ubuntu(
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: theaterMatches.length,
//                separatorBuilder: (BuildContext context, int Index) =>
//                    Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {
                      //key: Key(theaterMatches[Index].theaterFilmName()),

                      return Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                ((Index + 1).toString() +
                                    '. ' +
                                    theaterMatches[Index].theaterFilmName()),
                                style: GoogleFonts.ubuntu(
                                  fontSize: 20,
                                ),
                              ),
                            ),
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
//                        child: new ListTile(
//                          leading: Icon(Icons.album),
//                          title: Text((Index + 1).toString() +
//                              '. ' +
//                              theaterMatches[Index].theaterFilmName()),
//                        ),
                              //child: ,
                            ),
                            ExpansionTile(
                              leading: Text(
                                  theaterMatches[Index]
                                          .percentMatch()
                                          .toString() +
                                      '%',
                                  style: TextStyle(fontSize: 20)),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Get Details"),
                                ],
                              ),
                              children: <Widget>[
                                getGenreWidgets(
                                    theaterMatches[Index].getGenreResults(),
                                    theaterMatches[Index].theaterFilmGenres()),
                                //Text(theaterMatches[Index].getGenreResults()),

                                Text(theaterMatches[Index].theaterFilmPlot()),
                              ],
                            ),
                          ],
                        ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                }),
          ],
        ));
  }
}
