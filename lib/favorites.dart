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

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key key, this.uid, this.searchIndex}) : super(key: key);
  int searchIndex;
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
  int movieLength = 0;

  String movieCover = 'n/a';

  double movieScore = 0.0;

//----------this is for zipcode
  //final TextEditingController zipCtrl = new TextEditingController();
  var searchTheaterList = [];
  int searchChoice = 0;
  var _formKey = GlobalKey<FormState>();
  String zipString = '00000';

//----------for zipcode

  //List<String> movieGenres = List();
  final String apiKey = '45d251111f5b70015f4cc65e2b92d0d1';
  var currentUser = "Unknown";
  int searchNumber = 0;

  void initState() {
    super.initState();
  }

  _FavoritesState() {
    _auth.currentUser().then((user) {
      currentUser = user.uid;

      ref.child(currentUser + "/location/currentZipCode").once().then((ds) {
        zipString = ds.value;
      }).catchError((e) {
        print("None available for " + currentUser + " --- " + e.toString());
      });

      ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds) {
        ds.value.forEach((k, v) {
          movieTitle = k.replaceAll('%2E', '.');
          movieDate = v['releaseYear'];
          movieSummary = v['summary'];
          moviePosterLink = v['posterPath'];
          movieLength = v['runTime'];
          movieCover = v['coverPath'];
          movieScore = v['averageRating'].toDouble();

          //movieGenres = (v['genres']);
          var theFilm = new filmMovie(
              movieTitle,
              movieSummary,
              movieDate,
              moviePosterLink,
              v['genres'],
              movieLength,
              movieCover,
              movieScore);
          litems.add(theFilm);
        });
        setState(() {
          zipString = zipString;
          print("Length: " + litems.length.toString());
          litems.sort((a, b) => a.getFilmName().compareTo(b.getFilmName()));

        });
      }).catchError((e) {
        print("None available for " + currentUser + " --- " + e.toString());
      });
    }).catchError((e) {
      print("Failed to get the current user!" + e.toString());
    });

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
//--------------zipcode-----------------
            Container(
              padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 7),
              child: Text(
                "FAVORITE FILMS",
                style: GoogleFonts.ubuntu(
                  fontSize: 40,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    child: Text(
                      "Current Zip Code: " + zipString,
                      style: GoogleFonts.ubuntu(),
                    ),
                    onPressed: () {
                      zipCodeDialog(context).then((onValue) {
                        SnackBar zipBar = SnackBar(
                          content: Text("New Zip Code: " + onValue),
                        );

                        // Scaffold.of(context).showSnackBar(zipBar);
                      });
                    }),
                RaisedButton(
                    child: Text(
                      "+ Add a Film",
                      style: GoogleFonts.ubuntu(),
                    ),
                    onPressed: () {
                      addFilmDialog(context).then((onValue) {
                        if (onValue != "None") {
                          SnackBar movieBar = SnackBar(
                            content: Text("Added " + onValue),
                          );
                          print("Added film.");
                          //  Scaffold.of(context).showSnackBar(movieBar);
                        }

                        //
                      });
                    }),
              ],
            ),

            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / .90)),
                  //padding: const EdgeInsets.all(8),
                  itemCount: litems.length,
//                separatorBuilder: (BuildContext context, int Index) =>
//                    Divider(),
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Card(
//                      child: Dismissible(
//                        //key: Key(litems[Index].getFilmName()),
//                        onDismissed: (direction) {
//                          // Remove the item from the data source.
//
//                          setState(() {
//                            String removeMovie = litems[Index].getFilmName();
//                            litems.removeAt(Index);
//                            //litems.remove(litems[Index].getFilmName());
//                            ref
//                                .child(currentUser +
//                                    "/favoriteMovies/filmName/" +
//                                    removeMovie.replaceAll('.', '%2E'))
//                                .remove()
//                                .then((res) {
//                              //litems[Index].getFilmName()
//                              print("Movie is removed from database.");
//                            }).catchError((e) {
//                              print("Failed due to " + e);
//                            });
//
//                            counter = 1;
//                          });
//                        },
//                        // Show a red background as the item is swiped away.
//                        background: Container(color: Colors.red),

                      child: Column(
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height / 4,
                            //height: 175,
                            decoration: BoxDecoration(
                              image: new DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/original" +
                                        litems[Index].getFilmPoster()),
                                fit: BoxFit.fill,
                                //alignment: FractionalOffset.topCenter,
                              ),
                            ),
                            child: new InkResponse(
                              onTap: () {
                                print(litems[Index].getFilmName());
                                movieInfoDialog(context, litems[Index])
                                    .then((onValue) {
                                  if (onValue == "DELETE") {
                                    setState(() {
                                      String removeMovie =
                                          litems[Index].getFilmName();
                                      litems.removeAt(Index);
                                      //litems.remove(litems[Index].getFilmName());
                                      ref
                                          .child(currentUser +
                                              "/favoriteMovies/filmName/" +
                                              removeMovie.replaceAll(
                                                  '.', '%2E'))
                                          .remove()
                                          .then((res) {
                                        //litems[Index].getFilmName()
                                        print(
                                            "Movie is removed from database.");
                                      }).catchError((e) {
                                        print("Failed due to " + e);
                                      });
                                    });

//                                                                setState(() {

//
//                            counter = 1;
//                          });
//                        },

                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            alignment: Alignment.center,
                            child: Text(
                              (Index + 1).toString() +
                                  '. ' +
                                  litems[Index].getFilmName(),
                              style: GoogleFonts.ubuntu(),
                              textAlign: TextAlign.center,
                            ),
                          ),

//-----------------------------------------
//                          ExpansionTile(
////                            onTap: (){
////                              new Card(
////                              );
////                            },
//                            //leading: Icon(Icons.laptop_chromebook),
//                            leading: CircleAvatar(
//                              backgroundImage: NetworkImage(
//                                  "https://image.tmdb.org/t/p/w500" +
//                                      litems[Index].getFilmPoster()),
//                            ),
//
////                          trailing: IconButton(
////                            onPressed: () {},
////                            icon: Icon(
////                              Icons.keyboard_arrow_down,
////                              color: Colors.white,
////                            ),
////
////                          ),
//                            title: Container(
//                              child: Text(
//                                (Index + 1).toString() +
//                                    '. ' +
//                                    litems[Index].getFilmName(),
//                                style: TextStyle(
//                                    backgroundColor: Colors.white,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            ),
//
//                            children: <Widget>[
//                              Container(
//                                color: Colors.white,
//                                child: Column(
//                                  children: <Widget>[
//                                    Text("# of Genres: " +
//                                        litems[Index]
//                                            .getFilmGenres()
//                                            .length
//                                            .toString()),
//                                    Container(
//                                      //color: Colors.white,
//                                      padding: EdgeInsets.all(10),
//                                      child: Text(litems[Index].getSummary()),
//                                    ),
//                                  ],
//                                ),
//                              ),
//
//                              //print(_getSummary());
//                            ],
//                          ),
                          //-----------------------------------------
                        ],
                      ),
                      // ),
                    );
                  }),
            ),
            RaisedButton(
              child: Text("SAVE"),
              onPressed: () {
                print("MOVING ON---------------");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              listOfFaves: litems,
                              zipCode: zipString,
                            )));
              },
            ),
          ],
        ));
  }

  Future<String> addFilmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add Film", style: GoogleFonts.ubuntu()),
            content: new TextField(
              controller: eCtrl,
              decoration: InputDecoration(labelText: "   Enter film name here"),
              //maybe put a flatbutton search onPressed()
//              onSubmitted: (text) async{
//
//              },
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Text(
                    "GO BACK",
                    style: GoogleFonts.ubuntu(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("None");
                  }),
              MaterialButton(
                  child: Text("SEARCH", style: GoogleFonts.ubuntu()),
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
                      if (resSummary['results'][i]['release_date'] == null ||
                          resSummary['results'][i]['release_date'] == "") {
                        yearDate = '?';
                      } else {
                        yearDate = resSummary['results'][i]['release_date']
                            .substring(
                                0,
                                resSummary['results'][i]['release_date']
                                    .indexOf('-'));
                      }
                      searchFilmList.add({
                        "title": resSummary['results'][i]['title'] +
                            " (" +
                            yearDate +
                            ")",
                      });
                      print(i.toString() + ". " + searchFilmList[i]['title']);
                    }
                    print(searchFilmList.length);

                    searchNumber = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => new SearchFilmPage(
                            listSearch: searchFilmList,
                          ),
                          fullscreenDialog: true,
                        ));

//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => SearchFilmPage(listSearch: searchFilmList)),);

                    print(resSummary['results'][searchNumber]['id']);
                    String resLinkForMovie = "https://api.themoviedb.org/3/movie/" +
                        resSummary['results'][searchNumber]['id'].toString() +
                        "?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US";
                    print(resLinkForMovie);
                    var resGet = await http.get(resLinkForMovie);

                    var resFullMovie = jsonDecode(resGet.body);

                    movieTitle = resSummary['results'][searchNumber]['title'] +
                        " (" +
                        resSummary['results'][searchNumber]['release_date']
                            .substring(
                                0,
                                resSummary['results'][searchNumber]
                                        ['release_date']
                                    .indexOf('-')) +
                        ")";
                    movieSummary =
                        resSummary['results'][searchNumber]['overview'];
                    movieDate = resSummary['results'][searchNumber]
                            ['release_date']
                        .substring(
                            0,
                            resSummary['results'][searchNumber]['release_date']
                                .indexOf('-'));

                    movieLength = resFullMovie["runtime"];
                    movieCover = resFullMovie["backdrop_path"];
                    movieScore = resFullMovie["vote_average"];

                    String coverLink = "";
                    if (resSummary["results"][searchNumber]["backdrop_path"] == null){
                      if(resSummary["results"][searchNumber]["poster_path"] == null){
                        coverLink = "/k7cS0S3V5nTEHXb0d9SPbc0yCTj.jpg";
                      }
                      else{
                        coverLink = resSummary["results"][searchNumber]["poster_path"];
                      }
                    }
                    else{
                      coverLink = resSummary["results"][searchNumber]["backdrop_path"];
                    }




                    moviePosterLink =
                        resSummary['results'][searchNumber]['poster_path'];
                    List<dynamic> movieGenres = [];
                    //movieGenres =resSummary['results'][searchNumber]['genre_ids'];
                    for (int j = 0;
                        j <
                            resSummary['results'][searchNumber]['genre_ids']
                                .length;
                        j++) {
                      String whatGenre = getGenre(
                          resSummary['results'][searchNumber]['genre_ids'][j]);
                      print(whatGenre.toString());
                      movieGenres.add(whatGenre.toString());
                    }
                    print(movieTitle);
                    print(movieSummary);
                    print(movieDate);
                    print(movieLength);
                    print(movieCover);
                    print(movieScore);
                    print(movieGenres);
                    ref
                        .child(currentUser +
                            "/favoriteMovies/filmName/" +
                            movieTitle.replaceAll('.', '%2E'))
                        .set({
                      "releaseYear": movieDate,

                      "summary": movieSummary,
                      "posterPath": moviePosterLink,
//                "releaseYear": resSummary['results'][searchNumber]
//                        ['release_date']
//                    .substring(
//                        0,
//                        resSummary['results'][searchNumber]['release_date']
//                            .indexOf('-')),
//                "summary": resSummary['results'][searchNumber]['overview'],
//                "posterPath": resSummary['results'][searchNumber]
//                    ['poster_path'],
                      "genres": movieGenres,
                      "runTime": movieLength,
                      "coverPath": coverLink,
                      "averageRating": movieScore,

                      //"genres": movieGenres,
                    }).then((res) {
                      print("Movie is added to database.");
                    }).catchError((e) {
                      print("Failed due to " + e);
                    });

                    var theFilm = new filmMovie(
                        movieTitle,
                        movieSummary,
                        movieDate,
                        moviePosterLink,
                        movieGenres,
                        movieLength,
                        coverLink,
                        movieScore);
                    movieSummary = theFilm.getSummary();
//                print(theFilm.getFilmName());
//                print(theFilm.getSummary());
                    litems.add(theFilm);
                    eCtrl.clear();
                    print("litems length: " + litems.length.toString());
                    setState(() {
                      counter = 1;
                    });

                    Navigator.of(context).pop(movieTitle);
                  }),
            ],
          );
        });
  }

  Future<String> zipCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          final TextEditingController zipCtrl = new TextEditingController();
          return AlertDialog(
            title: Text("Change Zip Code?", style: GoogleFonts.ubuntu()),
            content: TextField(

              maxLength: 5,
              controller: zipCtrl,
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Text(
                    "GO BACK",
                    style: GoogleFonts.ubuntu(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(zipString);
                  }),
              MaterialButton(
                child: Text(
                  "CHANGE",
                  style: GoogleFonts.ubuntu(),
                ),
                onPressed: () {
                  setState(() {

                      zipString = zipCtrl.text;

                  });

                  ref.child(currentUser + "/location/").set({
                    "currentZipCode": zipString,
                  }).then((res) {
                    print("Zip code changed.");
                  }).catchError((e) {
                    print("Failed due to " + e);
                  });

                  Navigator.of(context).pop(zipString);
                },
              ),
            ],
          );
        });
  }

  movieInfoDialog(BuildContext context, filmMovie movie) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Color.fromARGB(255, 76, 187, 204),
            content: Card(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
//                    height: MediaQuery.of(context).size.height /4.15,
//                    //padding: EdgeInsets.all(20),
//                    //height: 200,
//                    decoration: BoxDecoration(
//                      image: new DecorationImage(
//                        image: NetworkImage("https://image.tmdb.org/t/p/w500" +
//                            movie.getFilmCover()),
//                        fit: BoxFit.fitWidth,
//                        alignment: FractionalOffset.topCenter,
//                      ),
//                    ),

                      child: Image(
                        image: NetworkImage("https://image.tmdb.org/t/p/w500" +
                            movie.getFilmCover()),
                      ),
                    ),
                    Container(
                      //color: Colors.white,
                      padding: EdgeInsets.only(top: 10),
                      child: Text(movie.getFilmName(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                      //color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: Text(" " + movie.getSummary(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu()),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      child: getGenres(movie.getFilmGenres()),
                    ),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                            movie
                                .getLength()
                                .toString() +
                                " min",
                            style: GoogleFonts.ubuntu()),
                        Text(
                            "TMDb Score: " +
                                movie
                                    .getFilmScore().toString(),
                            style: GoogleFonts.ubuntu()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Go Back", style: GoogleFonts.ubuntu()),
                          onPressed: () {
                            Navigator.of(context).pop("nah");
                          },
                        ),
                        RaisedButton(
                          child: Text("Delete Film", style: GoogleFonts.ubuntu(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop("DELETE");
                          },
                        ),
                      ],
                    ),




                  ],
                ),
              ),


            ),

          );
        });
  }

  Widget getGenres(List movieList) {
    List<Widget> list = new List<Widget>();
    list.add(new Text("Genres: ", style: GoogleFonts.ubuntu()));
    for (var i = 0; i < movieList.length; i++) {
      list.add(new Text(movieList[i], style: GoogleFonts.ubuntu()));
      if (i != movieList.length - 1) list.add(new Text(", "));
    }
    return new Wrap(alignment: WrapAlignment.center, children: list);
  }

  String getGenre(int genreID) {
    if (genreID == 28) {
      return "Action";
    }
    if (genreID == 12) {
      return "Adventure";
    }
    if (genreID == 16) {
      return "Animated";
    }
    if (genreID == 35) {
      return "Comedy";
    }
    if (genreID == 80) {
      return "Crime drama";
    }
    if (genreID == 99) {
      return "Documentary";
    }
    if (genreID == 18) {
      return "Drama";
    }
    if (genreID == 10751) {
      return "Family";
    }
    if (genreID == 14) {
      return "Fantasy";
    }
    if (genreID == 27) {
      return "Horror";
    }
    if (genreID == 36) {
      return "History";
    }
    if (genreID == 10402) {
      return "Musical";
    }
    if (genreID == 9648) {
      return "Mystery";
    }
    if (genreID == 10749) {
      return "Romance";
    }
    if (genreID == 878) {
      return "Science fiction";
    }
    if (genreID == 10770) {
      return "TV Movie";
    }
    if (genreID == 53) {
      return "Thriller";
    }
    if (genreID == 10752) {
      return "War";
    }
    if (genreID == 37) {
      return "Western";
    }

    return "x";
  }
}

class filmMovie {
  String filmPlot;
  String filmName;
  String filmReleaseDate;
  String filmPoster;
  List filmGenres;
  int filmLength;
  String filmCover;

  //String filmRating;
  double filmScore;

  filmMovie(this.filmName, this.filmPlot, this.filmReleaseDate, this.filmPoster,
      this.filmGenres, this.filmLength, this.filmCover, this.filmScore) {}

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

  List getFilmGenres() {
    return filmGenres;
  }

  int getLength() {
    return filmLength;
  }

  String getFilmCover() {
    return filmCover;
  }

  double getFilmScore() {
    return filmScore;
  }
}
