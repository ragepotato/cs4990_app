import 'package:cs4990_app/genreSearch.dart';
import 'package:cs4990_app/theaterFind.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'pulled.dart';
import 'discover.dart';
import 'favorites.dart';
import 'apiPractice.dart';
import 'opening.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchResults.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //  This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: openingPage(),
        routes: <String, WidgetBuilder>{
          "/DiscoverPage": (BuildContext context) => new MyDiscoverPage(),
          "/FavoritesPage": (BuildContext context) => new FavoritesPage()
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.uid, this.listOfFaves, this.zipCode})
      : super(key: key);
  final String uid;
  final String title;
  final List listOfFaves;
  final String zipCode;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  var currentUser = "Unknown";
  var faveFilmsList = [];
  var _isSearchDisabled = false;
  String zipString = '33815';
  int totalTime = 0;
  double averageRating = 0.0;

//  String searchPlace = "http://data.tmsapi.com/v1.1/movies/showings?startDate=2020-03-28&zip=33602&api_key=ewgmhk7qeyw8jcwrzspw8k2w";
//  var currentDate = "2020-03-28" ;
//  var now = new DateTime.now();

  var listOfFilmsInTheaters = [];

  _MyHomePageState() {
    // var faveFilmsList = List<filmMovie>();

    _auth.currentUser().then((user) {
      currentUser = user.uid;

      ref.child(currentUser + "/location/currentZipCode").once().then((ds) {
        if (ds.value == null) {
          ref.child(currentUser + "/location/").set({
            "currentZipCode": "33815",
          }).then((res) {
            print("Zip code changed.");
          }).catchError((e) {
            print("Failed due to " + e);
          });
        }
        zipString = ds.value;
        print("zipString's value: " + zipString);

        var now = new DateTime.now();
        var currentDate = new DateFormat("yyyy-MM-dd").format(now);

//        ref.child(currentUser + "/location/zipCode/" + zipString).once().then((ds){
//          print(ds.value);
//          if (ds.value == null){ //zipcode is not in the database
//
//          }
//
//        });

        ref
            .child(currentUser +
                "/location/zipCode/" +
                zipString +
                "/" +
                currentDate)
            .once()
            .then((ds) async {
          if (ds.value == null) {
            //date is not there
            print("--------have to retrieve data from GraceNote---------");
            String searchPlace =
                "http://data.tmsapi.com/v1.1/movies/showings?startDate=" +
                    currentDate.toString() +
                    "&zip=" +
                    zipString +
                    "&api_key=92n2weg9gk3ew2fnbxhxux26";
            print(searchPlace);
            //------

            var res = await http.get(searchPlace);
            var resLocation = jsonDecode(res.body);

            for (int i = 0; i < resLocation.length; i++) {
              print(resLocation[i]["title"]);

              var specificRes = await http.get(
                  "https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=" +
                      resLocation[i]['title'] +
                      "&page=1&include_adult=false&year=" +
                      resLocation[i].toString());
              var specResLocation = jsonDecode(specificRes.body);
              String theRating = "";
//              if(resLocation[i].containsKey("ratings")){
//                theRating = "Not here";
//              }

              if (resLocation[i]["ratings"] == null ||
                  resLocation[i]["ratings"] == "") {
                theRating = "unrated";
              } else {
                theRating = resLocation[i]["ratings"][0]["code"];
              }
              String coverLink = "";
              if (specResLocation["results"][0]["backdrop_path"] == null) {
                if (specResLocation["results"][0]["poster_path"] == null) {
                  coverLink = "/k7cS0S3V5nTEHXb0d9SPbc0yCTj.jpg";
                } else {
                  coverLink = specResLocation["results"][0]["poster_path"];
                }
              } else {
                coverLink = specResLocation["results"][0]["backdrop_path"];
              }

              print("theRating: " + theRating);

              ref
                  .child(currentUser +
                      "/location/zipCode/" +
                      zipString +
                      "/" +
                      currentDate +
                      "/" +
                      resLocation[i]["title"].replaceAll('.', '%2E'))
                  .set({
                "summary": specResLocation["results"][0]["overview"],
                "releaseYear": resLocation[i]["releaseYear"].toString(),
                "posterPath": specResLocation["results"][0]["poster_path"],
                "genres": getGenre(specResLocation["results"][0]['genre_ids']),
                "runTime": resLocation[i]["runTime"],
                "mpaaRating": theRating,
                "showtimes": resLocation[i]["showtimes"],
                "coverPath": coverLink,

                "averageRating":
                    specResLocation["results"][0]["vote_average"].toString(),

                //
              }).then((res) {
                // print(newFilm.theaterFilmGenres());

                print("ADDED " + resLocation[i]["title"]);
              }).catchError((e) {
                print("Failed due to " + e);
              });
              var newFilm = new theaterMovie(
                  resLocation[i]["title"],
                  specResLocation["results"][0]["overview"],
                  resLocation[i]["releaseYear"].toString(),
                  specResLocation["results"][0]["poster_path"],
                  getGenre(specResLocation["results"][0]['genre_ids']),
                  resLocation[i]["runTime"],
                  theRating,
                  coverLink,
                  specResLocation["results"][0]["vote_average"].toString(),
                  resLocation[i]["showtimes"]);

              listOfFilmsInTheaters.add(newFilm);
//              print(resLocation[i]["title"]);
//              print("Summary: " + newFilm.theaterFilmPlot());
//              print("releaseYear: " + newFilm.theaterFilmYear());
//              print("posterPath: " + newFilm.theaterFilmPoster());
//              print("genres: " + newFilm.theaterFilmGenres().toString());
//              print("runTime: " + newFilm.theaterFilmLength().toString());
//              print("mpaaRating: " + newFilm.theaterScore());
//              // print("showtimes: " + );
//              print("coverPath: " + newFilm.theaterCover());
//              print("averageRating: " + newFilm.theaterFilmRating());
//              print("showtimes: " + resLocation[i]["showtimes"].runtimeType.toString());

            }
            print(
                "Number of films: " + listOfFilmsInTheaters.length.toString());

            print("Done with 1.");
          } else {
            print("Data is already here.");

            print("------data is ready to go------");
            print(currentUser +
                "/location/zipCode/" +
                zipString +
                "/" +
                currentDate.toString());
            ref
                .child(currentUser +
                    "/location/zipCode/" +
                    zipString +
                    "/" +
                    currentDate.toString())
                .once()
                .then((ds) {
              ds.value.forEach((k, v) {
                var theFilm = new theaterMovie(
                    k.replaceAll('%2E', '.'),
                    v['summary'],
                    v['releaseYear'],
                    v['posterPath'],
                    v['genres'],
                    v['runTime'],
                    v['mpaaRating'],
                    v['coverPath'],
                    v['averageRating'],
                    v['showtimes']);
                listOfFilmsInTheaters.add(theFilm);
              });

              print("list of films in theaters length: " +
                  listOfFilmsInTheaters.length.toString());

              _isSearchDisabled = false;
              print("SEARCH IS ON");
            }).catchError((e) {
              _isSearchDisabled = true;
              print("Search1 is disabled.");
              print("LALALALALALALALA " + currentUser + " --- " + e.toString());
            });
          }
        }).catchError((e) {
          _isSearchDisabled = true;
          print("Search2 is disabled.");
          print("This failed due to " + e);
        });
      }).catchError((e) {
        _isSearchDisabled = true;
        print("Search3 is disabled.");
        print(
            "None available for 22222" + currentUser + " --- " + e.toString());
      });

      //-------------------uncomment---------------------
      ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds) {
        ds.value.forEach((k, v) {
//                                  movieTitle = k;
//                                  movieDate = v['releaseYear'];
//                                  movieSummary = v['summary'];
//                                  moviePosterLink = v['posterPath'];

          //movieGenres = (v['genres']);
          var theFilm = new filmMovie(
              k,
              v['summary'],
              v['releaseYear'],
              v['posterPath'],
              v['genres'],
              v['runTime'],
              v['coverPath'],
              v['averageRating'].toDouble());
          faveFilmsList.add(theFilm);
        });

        setState(() {
          print("Length: " + faveFilmsList.length.toString());
          print("Done with 2.");
          _isSearchDisabled = false;
          print("SEARCH IS ON");
        });
      }).catchError((e) {
        _isSearchDisabled = true;
        print("Search4 is disabled.");
        print(
            "None available for 333333" + currentUser + " --- " + e.toString());
      });
// -------------------uncomment---------------------
    }).catchError((e) {
      print("Failed to get the current user!" + e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 76, 187, 204),
      // body: new Stack(

      body: Stack(
        children: <Widget>[
//          Container(
//            decoration: new BoxDecoration(
//              image: new DecorationImage(
//                //image: new AssetImage("Parasite-poster-2.jpg"),
//                image: new AssetImage("parasite1.jpg"),
//                //image: new AssetImage("parasite1.jpg"),
//                fit: BoxFit.cover,
//              ),
//            ),
//            child: new BackdropFilter(
//              filter: new ImageFilter.blur(
//                sigmaX: 3.0,
//                sigmaY: 3.0,
//              ),
//              child: new Container(
//                decoration: new BoxDecoration(
//                  color: Colors.black.withOpacity(0.3),
//                ),
//              ),
//            ),
//          ),
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 30,
                  child: Container(
                    //margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            "SeeNext",
                            style: GoogleFonts.lobster(fontSize: 75.0),
                          ),
                        ),

                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 230,
                          height: 70,
                          elevation: _isSearchDisabled ? 0 : 5,
                          color: _isSearchDisabled ? Colors.grey : Colors.blue,
                          textColor:
                              _isSearchDisabled ? Colors.black : Colors.white,

                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            setState(() {
                              if (listOfFilmsInTheaters.length == 0) {
                                _isSearchDisabled = true;
                              } else {
                                _isSearchDisabled = false;
                              }
                            });

                            if (_isSearchDisabled) {
                              print("Search is off");
                              return null;
                            } else {
                              print("New Search activated.");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyDiscoverPage(
                                          uid: widget.uid,
                                          theaterMovies: listOfFilmsInTheaters,
                                        )),
                              );
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                _isSearchDisabled
                                    ? "No Films"
                                    : "Search by",
                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                              Text(
                                _isSearchDisabled
                                 ?"At Location" : "New Criteria",

                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                              ],
                          ),







                        ),
                        MaterialButton(
                          minWidth: 230,
                          height: 70,
                          elevation: _isSearchDisabled ? 0 : 5,
                          color: _isSearchDisabled ? Colors.grey : Colors.blue,
                          textColor:
                              _isSearchDisabled ? Colors.black : Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              if (listOfFilmsInTheaters.length == 0 ||
                                  faveFilmsList.length < 2) {
                                _isSearchDisabled = true;
                              } else {
                                _isSearchDisabled = false;
                              }
                            });

                            if (_isSearchDisabled) {
                              print("Search is off");
                              return null;
                            } else {
                              var genreMap = Map();
                              print("Search by preferences activated.");
                              print("List length: " +
                                  faveFilmsList.length.toString());
                              totalTime = 0;
                              averageRating = 0.0;

                              bool acclaimMatters = false;

                              for (int w = 0; w < faveFilmsList.length; w++) {
                                averageRating +=
                                    faveFilmsList[w].getFilmScore();

                                totalTime += faveFilmsList[w].getLength();

                                faveFilmsList[w]
                                    .getFilmGenres()
                                    .forEach((element) {
                                  if (!genreMap.containsKey(element)) {
                                    genreMap[element] = 1;
                                  } else {
                                    genreMap[element] += 1;
                                  }
                                });
                              }

                              int averageTime =
                                  (totalTime / faveFilmsList.length).round();
                              averageRating =
                                  (averageRating / faveFilmsList.length);
                              if (averageRating > 7.0) acclaimMatters = true;

                              print("Average time of favorites: " +
                                  averageTime.toString());
                              print("Average rating of favorites: " +
                                  averageRating.toString());

                              var sortedKeys = genreMap.keys
                                  .toList(growable: false)
                                    ..sort((k1, k2) =>
                                        genreMap[k2].compareTo(genreMap[k1]));
                              LinkedHashMap sortedMap =
                                  new LinkedHashMap.fromIterable(sortedKeys,
                                      key: (k) => k, value: (k) => genreMap[k]);
                              var genreList = sortedMap.keys.toList();
                              var pointCount = sortedMap.values.toList();
                              print(sortedMap);

                              print("1. " + genreList[0]);
                              print("2. " + genreList[1]);
                              print("3. " + genreList[2]);
                              List searchPrefFaveGenres = [];
                              searchPrefFaveGenres.add(genreList[0]);
                              searchPrefFaveGenres.add(genreList[1]);
                              searchPrefFaveGenres.add(genreList[2]);

                              for (int i = 0;
                                  i < listOfFilmsInTheaters.length;
                                  i++) {
                                int totalPossible = 0;
                                listOfFilmsInTheaters[i].setGenreMatchCount(0);

                                if (acclaimMatters) totalPossible += 2;

                                if (acclaimMatters &&
                                    double.parse(listOfFilmsInTheaters[i]
                                            .theaterScore()) >=
                                        7.0) {
                                  listOfFilmsInTheaters[i].setGenreMatchCount(
                                      listOfFilmsInTheaters[i].totalMatch() +
                                          2);
                                  print("We care about acclaim! " +
                                      listOfFilmsInTheaters[i]
                                          .theaterFilmName() +
                                      " is acclaimed. + 2");
                                }

                                if (listOfFilmsInTheaters[i]
                                            .theaterFilmLength() <=
                                        (averageTime + 15) &&
                                    listOfFilmsInTheaters[i]
                                            .theaterFilmLength() >=
                                        (averageTime - 15)) {
                                  print(listOfFilmsInTheaters[i]
                                          .theaterFilmName() +
                                      " is within 15 minutes. + 2");
                                  listOfFilmsInTheaters[i].setGenreMatchCount(
                                      listOfFilmsInTheaters[i].totalMatch() +
                                          2);
                                }
                                totalPossible += 2;

                                int count = 0;

                                for (int h = 0; h < genreList.length; h++) {
                                  totalPossible += 1;
                                  if (listOfFilmsInTheaters[i]
                                      .theaterFilmGenres()
                                      .contains(genreList[h])) {
                                    print(genreList[h] +
                                        " is a genre! +" +
                                        pointCount[h].toString());
                                    count += pointCount[h];
                                  }
                                }

                                listOfFilmsInTheaters[i].setGenreMatchCount(
                                    count +
                                        listOfFilmsInTheaters[i].totalMatch());
                                print(
                                    listOfFilmsInTheaters[i].theaterFilmName() +
                                        ": " +
                                        listOfFilmsInTheaters[i]
                                            .theaterFilmLength()
                                            .toString());
                                print("Total count: " +
                                    listOfFilmsInTheaters[i]
                                        .totalMatch()
                                        .toString());
                                print("Total possible: " +
                                    totalPossible.toString());
                                listOfFilmsInTheaters[i]
                                    .getTotalPossible(totalPossible);
                              }
                              listOfFilmsInTheaters.sort((a, b) =>
                                  b.totalMatch().compareTo(a.totalMatch()));
                              print("Highest match: " +
                                  listOfFilmsInTheaters[0].theaterFilmName());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchResultsPage(
                                          uid: widget.uid,
                                          listMatches: listOfFilmsInTheaters,
                                          isSearchPreferences: 1,
                                          favoriteGenres: searchPrefFaveGenres,
                                        )),
                              );
                              ;
                              setState(() {
                                // _NoSearchPress();print(_isSearchDisabled);
                              });
                            }

                            //_isSearchDisabled ? null : print(_isSearchDisabled);
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                _isSearchDisabled
                                    ? "No Available"
                                    : "Search by",
                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                              Text(
                                _isSearchDisabled ? "Films" : "Preferences",
                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        //Text("Hello"),
                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Text(""),

                        MaterialButton(
                          elevation: 5,
                          minWidth: 230,
                          height: 70,
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
//                          padding: EdgeInsets.only(
//                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("Search by preferences activated.");
                            print(widget.uid);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FavoritesPage(uid: widget.uid)),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Change Favorites",
                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                              Text(
                                "or Zip Code",
                                style: GoogleFonts.ubuntu(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),

                        MaterialButton(
                          elevation: 5,
                          height: 70,
                          minWidth: 230,
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

//                              padding: EdgeInsets.only(
//                                  left: 52.5, top: 15.0, right: 52.5, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
//                            print(listOfFilmsInTheaters[0].theaterFilmLength());
//                            print(listOfFilmsInTheaters[0].theaterShowtimeMap().toString());
//                            print(listOfFilmsInTheaters[0].theaterShowtimeMap().length.toString());
//                            print(listOfFilmsInTheaters[0].theaterShowtimeMap()[0]['dateTime'].toString());
//                            print(listOfFilmsInTheaters[0].theaterShowtimeMap()[0]['theatre']['name'].toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => openingPage()),
                            );
                          },
                          child: Text(
                            "Sign Out",
                            style: GoogleFonts.ubuntu(fontSize: 20.0),
                          ),
                        ),

                        //Text("Hello"),
                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List getGenre(List genreID) {
    List<String> genreName = List(genreID.length);
    for (int i = 0; i < genreID.length; i++) {
      if (genreID[i] == 28) {
        genreName[i] = "Action";
      } else if (genreID[i] == 12) {
        genreName[i] = "Adventure";
      } else if (genreID[i] == 16) {
        genreName[i] = "Animated";
      } else if (genreID[i] == 35) {
        genreName[i] = "Comedy";
      } else if (genreID[i] == 80) {
        genreName[i] = "Crime drama";
      } else if (genreID[i] == 99) {
        genreName[i] = "Documentary";
      } else if (genreID[i] == 18) {
        genreName[i] = "Drama";
      } else if (genreID[i] == 10751) {
        genreName[i] = "Family";
      } else if (genreID[i] == 14) {
        genreName[i] = "Fantasy";
      } else if (genreID[i] == 27) {
        genreName[i] = "Horror";
      } else if (genreID[i] == 36) {
        genreName[i] = "History";
      } else if (genreID[i] == 10402) {
        genreName[i] = "Musical";
      } else if (genreID[i] == 9648) {
        genreName[i] = "Mystery";
      } else if (genreID[i] == 10749) {
        genreName[i] = "Romance";
      } else if (genreID[i] == 878) {
        genreName[i] = "Science fiction";
      } else if (genreID[i] == 10770) {
        genreName[i] = "TV Movie";
      } else if (genreID[i] == 53) {
        genreName[i] = "Thriller";
      } else if (genreID[i] == 10752) {
        genreName[i] = "War";
      } else if (genreID[i] == 37) {
        genreName[i] = "Western";
      } else
        genreName[i] = "x";
      //print(genreName[i]);
    }

    return genreName;
  }

  Function _NoSearchPress() {
    if (_isSearchDisabled) {
      print("Can't search");
      return null;
    } else {
      print("SEARCHING");

      return () async {};
    }
  }
}

class theaterMovie {
  String filmPlot;
  String filmName;
  String filmReleaseDate;
  String filmPoster;
  List filmGenres;
  int totalGenreCount;
  String filmLength;
  String filmRating;
  List filmShowtimes;
  String filmCover;
  String filmAvgScore;

  int matchPercent;
  List genreMatches;
  List showtimeMap;

  //rating, showtimes, coverPath, averageRating

  theaterMovie(
      this.filmName,
      this.filmPlot,
      this.filmReleaseDate,
      this.filmPoster,
      this.filmGenres,
      this.filmLength,
      this.filmRating,
      this.filmCover,
      this.filmAvgScore,
      this.showtimeMap) {
    matchPercent = 0;
  }

  String theaterFilmName() {
    return filmName;
  }

  String theaterFilmPlot() {
    return filmPlot;
  }

  String theaterFilmYear() {
    return filmReleaseDate;

    //  return filmReleaseDate.substring(0, filmReleaseDate.indexOf('-'));
  }

  String theaterFilmPoster() {
    return filmPoster;
  }

  List theaterFilmGenres() {
    return filmGenres;
  }

  int theaterFilmLength() {
    var hour = int.parse(filmLength.substring(3, 4));
    var min = int.parse(filmLength.substring(5, 7));

    return (hour * 60) + min;
  }

  void setGenreMatchCount(int count) {
    totalGenreCount = count;
  }

  int totalMatch() {
    return totalGenreCount;
  }

  String theaterFilmRating() {
    return filmRating;
  }

  List theaterShowtimes() {
    return filmShowtimes;
  }

  String theaterCover() {
    return filmCover;
  }

  String theaterScore() {
    return filmAvgScore;
  }

  void getTotalPossible(int count) {
    matchPercent = ((totalGenreCount / count) * 100).round();
  }

  int percentMatch() {
    return matchPercent;
  }

  void genresThatMatch(List genres) {
    genreMatches = genres;
  }

  List getGenreResults() {
    return genreMatches;
  }

  List theaterShowtimeMap() {
    return showtimeMap;
  }
}
