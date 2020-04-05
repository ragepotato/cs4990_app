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
  SearchResultsPage(
      {Key key,
      this.uid,
      this.listMatches,
      this.isSearchPreferences,
      this.favoriteGenres})
      : super(key: key);
  List listMatches;
  final String uid;
  int isSearchPreferences;
  List favoriteGenres;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResultsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  var currentUser = "Unknown";


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
        backgroundColor: Color.fromARGB(255, 76, 187, 204),
//        appBar: new AppBar(
//          title: new Text("Hello, $currentUser"),
//
//        ),
        body: new Column(
          children: <Widget>[
            topOfPage(widget.isSearchPreferences),
            Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
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
                                  Text("Get Details",
                                      style: GoogleFonts.ubuntu()),
                                ],
                              ),
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    getGenreWidgets(
                                        theaterMatches[Index].getGenreResults(),
                                        theaterMatches[Index]
                                            .theaterFilmGenres(),
                                        widget.isSearchPreferences),
                                    //Text(theaterMatches[Index].getGenreResults()),

                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                          " " +
                                              theaterMatches[Index]
                                                  .theaterFilmPlot(),
                                          style: GoogleFonts.ubuntu()),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                            "MPAA Rating: " +
                                                theaterMatches[Index]
                                                    .theaterFilmRating(),
                                            style: GoogleFonts.ubuntu()),
                                        Text(
                                            theaterMatches[Index]
                                                    .theaterFilmLength()
                                                    .toString() +
                                                " min",
                                            style: GoogleFonts.ubuntu()),
                                        Text(
                                            "TMDb Score: " +
                                                theaterMatches[Index]
                                                    .theaterScore(),
                                            style: GoogleFonts.ubuntu()),
                                      ],
                                    ),

                                    Container(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("Showing Today:", style: GoogleFonts.ubuntu()),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: showtimeDisplay(theaterMatches[Index].theaterShowtimeMap()),
                                    ),



                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    child: Text("Go Back"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                RaisedButton(
                    child: Text("Home"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    }),
              ],
            ),
          ],
        ));
  }

  Widget getGenreWidgets(
      List<dynamic> matchGenres, List<dynamic> allGenres, int isFaves) {
    List<Widget> list = new List<Widget>();
    list.add(new Text("Genres: ", style: GoogleFonts.ubuntu()));
    if (matchGenres != null) {
      print(matchGenres);
      for (var i = 0; i < allGenres.length; i++) {
        if (matchGenres.contains(allGenres[i])) {
          list.add(new Text(allGenres[i],
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)));

          if (i != allGenres.length - 1)
            list.add(new Text(", ", style: GoogleFonts.ubuntu()));
        } else {
          list.add(new Text(allGenres[i], style: GoogleFonts.ubuntu()));
          if (i != allGenres.length - 1)
            list.add(new Text(", ", style: GoogleFonts.ubuntu()));
        }
      }

      return new Wrap(alignment: WrapAlignment.center, children: list);
    } else if (isFaves == 1) {
      for (var i = 0; i < allGenres.length; i++) {
        if (widget.favoriteGenres.contains(allGenres[i])) {
          list.add(new Text(allGenres[i],
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)));

          if (i != allGenres.length - 1)
            list.add(new Text(", ", style: GoogleFonts.ubuntu()));
        } else {
          list.add(new Text(allGenres[i], style: GoogleFonts.ubuntu()));
          if (i != allGenres.length - 1)
            list.add(new Text(", ", style: GoogleFonts.ubuntu()));
        }
      }
      return new Wrap(children: list);
    } else {
      for (var i = 0; i < allGenres.length; i++) {
        list.add(new Text(allGenres[i]));
        if (i != allGenres.length - 1) list.add(new Text(", "));
      }
      return new Wrap(alignment: WrapAlignment.center, children: list);
    }
  }

  Widget topOfPage(int isSearch) {
    if (isSearch == 1) {
      List<Widget> list = new List<Widget>();
      list.add(new Text("Favorite genres: ", style: GoogleFonts.ubuntu()));
      for (var i = 0; i < widget.favoriteGenres.length; i++) {
        list.add(new Text((i + 1).toString() + ". " + widget.favoriteGenres[i],
            style: GoogleFonts.ubuntu()));
        if (i != widget.favoriteGenres.length - 1)
          list.add(new Text(", ", style: GoogleFonts.ubuntu()));
      }

      return Column(
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
          Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 9),
              child: Wrap(alignment: WrapAlignment.center, children: list))
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 7),
        child: Text(
          "RESULTS",
          style: GoogleFonts.ubuntu(
            fontSize: 40,
          ),
        ),
      );
    }
  }

  Widget showtimeDisplay(List showTimes) {  //listOfFilmsInTheaters[0].theaterShowtimeMap()
    List<Widget> list = new List<Widget>();
    for (int i = 0; i < showTimes.length; i++){
      list.add(new Container( padding: EdgeInsets.all(4), child: new Text(showTimes[i]['dateTime'].toString() + " - " + showTimes[i]['theatre']['name'].toString(), style: GoogleFonts.ubuntu()) ));
      //list.add(new Container( padding: EdgeInsets.all(3), child: new Text(showTimes[i]['dateTime'].toString() + " - " + showTimes[i]['theatre']['name'].toString(), style: GoogleFonts.ubuntu()) ));
    }
    return Column(children: list);
  }
}

