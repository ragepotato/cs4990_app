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
import 'searchFilms.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  int counter = 1;
  var litems = List<filmMovie>();

  //List<filmMovie> litems = [];
  String movieTitle = ' ';
  String movieSummary = 'n/a';
  String movieDate = 'n/a';
  String moviePosterLink = 'n/a';
  final String apiKey = '45d251111f5b70015f4cc65e2b92d0d1';
  var currentUser = "Unknown";

  _FavoritesState() {
    _auth.currentUser().then((user) {
      currentUser = user.uid;

      ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds) {
        ds.value.forEach((k, v) {
          movieTitle = k;
          movieDate = v['releaseYear'];
          movieSummary = v['summary'];
          moviePosterLink = v['posterPath'];
          print(moviePosterLink);
          var theFilm = new filmMovie(
              movieTitle, movieSummary, movieDate, moviePosterLink);
          litems.add(theFilm);
        });
        setState(() {
          print("Length: " + litems.length.toString());
        });
      }).catchError((e) {
        print("None available for " + currentUser + " --- " + e.toString());
      });
    }).catchError((e) {
      print("Failed to get the current user!" + e.toString());
    });
  }

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Hello, $currentUser"),
        ),
        body: new Column(
          children: <Widget>[
            new TextField(
              controller: eCtrl,
              decoration: InputDecoration(labelText: "   Enter film name here"),
              //maybe put a flatbutton search onPressed()
//              onSubmitted: (text) async{
//
//              },
            ),
            FlatButton(
                child: Text("SEARCH"),
                onPressed: () async {
                  String linkText = eCtrl.text.replaceAll(' ', '%20');
                  String sumText =
                      'https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=' +
                          linkText +
                          '&page=1&include_adult=false';
                  print(sumText);
                  var searchFilmList = [];
                  var res = await http.get(sumText);
                  var resSummary = jsonDecode(res.body);
                  //if (resSummary)
                  int howMany = min(resSummary['total_results'], 10);
                  print(howMany);

                  for (int i = 0; i < howMany; i++) {
                    String yearDate = '';
                    if (resSummary['results'][i]['release_date'] == ""){
                        yearDate = '?';
                    }
                    else{
                      yearDate = resSummary['results'][i]['release_date'].substring(0,resSummary['results'][i]['release_date'].indexOf('-'));
                    }
                    searchFilmList.add({

                    "title": resSummary['results'][i]['title'] + " (" + yearDate +")",
                    });
                    print(i.toString() + ". " + searchFilmList[i]['title']);
                  }
                  print(searchFilmList.length);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchFilmPage(listSearch: searchFilmList)),);


                  movieTitle = resSummary['results'][0]['title'] +
                      " (" +
                      resSummary['results'][0]['release_date'].substring(
                          0,
                          resSummary['results'][0]['release_date']
                              .indexOf('-')) +
                      ")";
                  movieSummary = resSummary['results'][0]['overview'];
                  movieDate = resSummary['results'][0]['release_date']
                      .substring(
                      0,
                      resSummary['results'][0]['release_date']
                          .indexOf('-'));
                  moviePosterLink = resSummary['results'][0]['poster_path'];
                  print("Here.");
                  ref
                      .child(currentUser +
                      "/favoriteMovies/filmName/" +
                      movieTitle)
                      .set({
                    "releaseYear": resSummary['results'][0]['release_date']
                        .substring(
                        0,
                        resSummary['results'][0]['release_date']
                            .indexOf('-')),
                    "summary": resSummary['results'][0]['overview'],
                    "posterPath": resSummary['results'][0]['poster_path'],
                  }).then((res) {
                    print("Movie is added to database.");
                  }).catchError((e) {
                    print("Failed due to " + e);
                  });

                  var theFilm = new filmMovie(
                      movieTitle, movieSummary, movieDate, moviePosterLink);
                  movieSummary = theFilm.getSummary();
//                print(theFilm.getFilmName());
//                print(theFilm.getSummary());
                  litems.add(theFilm);
                  eCtrl.clear();

                  setState(() {
                    counter = 1;
                  });
                }),
            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: litems.length,
                    separatorBuilder: (BuildContext context, int Index) =>
                        Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Dismissible(
                        key: Key(litems[Index].getFilmName()),
                        onDismissed: (direction) {
                          // Remove the item from the data source.

                          setState(() {
                            String removeMovie = litems[Index].getFilmName();
                            litems.removeAt(Index);
                            //litems.remove(litems[Index].getFilmName());
                            ref
                                .child(currentUser +
                                "/favoriteMovies/filmName/" +
                                removeMovie)
                                .remove()
                                .then((res) {
                              //litems[Index].getFilmName()
                              print("Movie is removed from database.");
                            }).catchError((e) {
                              print("Failed due to " + e);
                            });

                            counter = 1;
                          });

                          // Then show a snackbar.
//                          Scaffold.of(context).showSnackBar(SnackBar(
//                              content: Text(litems[Index] + " dismissed")));
                        },
                        // Show a red background as the item is swiped away.
                        background: Container(color: Colors.red),

                        child: Container(
                          color: Colors.greenAccent,
                          child: new ExpansionTile(
//                            onTap: (){
//                              new Card(
//                              );
//                            },
                            //leading: Icon(Icons.laptop_chromebook),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://image.tmdb.org/t/p/w500" +
                                      litems[Index].getFilmPoster()),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
//                                onPressed: (){
//                                  setState(() {
//
//                                  });
//                                },
                            ),
                            title: Text((Index + 1).toString() +
                                '. ' +
                                litems[Index].getFilmName()),

                            children: <Widget>[
                              //print(_getSummary());
                              //Text(_getSummary()),
                              Container(
                                padding: EdgeInsets.all(12),
                                child: Text(litems[Index].getSummary()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }
}

class filmMovie {
  String filmPlot;
  String filmName;
  String filmReleaseDate;
  String filmPoster;

  filmMovie(this.filmName, this.filmPlot, this.filmReleaseDate,
      this.filmPoster) {}

  String getFilmName() {
    return filmName;
  }

  String getSummary() {
    return filmPlot;
  }

  String getReleaseYear() {
    return filmReleaseDate;

    //  return filmReleaseDate.substring(0, filmReleaseDate.indexOf('-'));
  }

  String getFilmPoster() {
    return filmPoster;
  }
}
