import 'package:cs4990_app/genreSearch.dart';
import 'package:cs4990_app/theaterFind.dart';
import 'package:flutter/material.dart';
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
  String zipString = '78701';
  int totalTime = 0;

//  String searchPlace = "http://data.tmsapi.com/v1.1/movies/showings?startDate=2020-03-28&zip=33602&api_key=ewgmhk7qeyw8jcwrzspw8k2w";
//  var currentDate = "2020-03-28" ;
//  var now = new DateTime.now();

  var listOfFilmsInTheaters = [];

  _MyHomePageState() {
    // var faveFilmsList = List<filmMovie>();

    _auth.currentUser().then((user) {
      currentUser = user.uid;

      ref.child(currentUser + "/location/currentZipCode").once().then((ds){
        if (ds.value == null) {
          ref.child(currentUser + "/location/").set({
            "currentZipCode": "33602",
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


        ref.child(currentUser + "/location/zipCode/" + zipString + "/" + currentDate).once().then((ds) async {

          if (ds.value == null){             //date is not there
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


              var specificRes = await http.get("https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=" + resLocation[i]['title'] +"&page=1&include_adult=false&year=" + resLocation[i].toString());
              var specResLocation = jsonDecode(specificRes.body);
              String theRating = "";
//              if(resLocation[i].containsKey("ratings")){
//                theRating = "Not here";
//              }

              if (resLocation[i]["ratings"] == null || resLocation[i]["ratings"] == ""){
                theRating = "unrated";

              }
              else{
                theRating = resLocation[i]["ratings"][0]["code"];
              }

              print("theRating: " + theRating);

              ref
                  .child(currentUser +
                  "/location/zipCode/" +
                  zipString +
                  "/" +
                  currentDate +
                  "/" +
                  resLocation[i]["title"])
                  .set({
                "summary": specResLocation["results"][0]["overview"],
                "releaseYear": resLocation[i]["releaseYear"].toString(),
                "posterPath": specResLocation["results"][0]["poster_path"],
                "genres": getTheaterGenre(resLocation[i]['genres']),
                "runTime": resLocation[i]["runTime"],
                "mpaaRating": theRating,
                "showtimes": resLocation[i]["showtimes"],
                "coverPath": specResLocation["results"][0]["backdrop_path"],

                "averageRating": specResLocation["results"][0]["vote_average"],


              }).then((res) {
                print("ADDED " + resLocation[i]["title"]);
              }).catchError((e) {
                print("Failed due to " + e);
              });

              var newFilm = new theaterMovie(
                  resLocation[i]["title"],
                  resLocation[i]["longDescription"],
                  resLocation[i]["releaseYear"].toString(),
                  resLocation[i]["preferredImage"]["uri"],
                  getTheaterGenre(resLocation[i]['genres']),
                  resLocation[i]["runTime"]);

              listOfFilmsInTheaters.add(newFilm);

              //List theaterGenresFixed = getTheaterGenre(resLocation[i]['genres']);
              print(newFilm.theaterFilmGenres());
              print("Length: " + newFilm.theaterFilmLength().toString());
            }
            print(
                "Number of films: " + listOfFilmsInTheaters.length.toString());

            print("Done with 1.");




          }

          else{
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
                    k, v['summary'], v['releaseYear'], v['posterPath'], v['genres'], v['runTime']);
                listOfFilmsInTheaters.add(theFilm);
              });
              print("list of films in theaters length: " + listOfFilmsInTheaters.length.toString());

            }).catchError((e) {
              print("LALALALALALALALA " + currentUser + " --- " + e.toString());
            });
          }

        }).catchError((e) {
          print("This failed due to " + e);
        });


    }).catchError((e) {
      print("None available for 22222" + currentUser + " --- " + e.toString());
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
              v['averageRating']);
          faveFilmsList.add(theFilm);
        });

        setState(() {
          print("Length: " + faveFilmsList.length.toString());
          print("Done with 2.");
        });
      }).catchError((e) {
        print("None available for 333333" + currentUser + " --- " + e.toString());
      });
// -------------------uncomment---------------------
    }).catchError((e) {
      print("Failed to get the current user!" + e.toString());
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      // body: new Stack(

      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                //image: new AssetImage("Parasite-poster-2.jpg"),
                image: new AssetImage("parasite1.jpg"),
                //image: new AssetImage("parasite1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(
                sigmaX: 3.0,
                sigmaY: 3.0,
              ),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 60.0),
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
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,

                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

                          padding: EdgeInsets.only(
                              left: 54.0, top: 25.0, right: 54.0, bottom: 25.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            print("New Search activated.");
//                            var now = new DateTime.now();
//                            var currentDate =
//                            new DateFormat("yyyy-MM-dd").format(now);
//                            String searchPlace =
//                                "http://data.tmsapi.com/v1.1/movies/showings?startDate=" +
//                                    currentDate.toString() +
//                                    "&zip=" +
//                                    zipString +
//                                    "&api_key=ewgmhk7qeyw8jcwrzspw8k2w";
//                            print(searchPlace);
//                            //------
//                            var res = await http.get(searchPlace);
//                            var resLocation = jsonDecode(res.body);
//                            var listOfFilmsInTheaters = [];
//
//                            for (int i = 0; i < resLocation.length; i++) {
//                              print(resLocation[i]["title"]);
//                              //searchTheaterList.add(resLocation[i]["title"]);
//
//                              var newFilm = new theaterMovie(resLocation[i]["title"], resLocation[i]["longDescription"], resLocation[i]["releaseYear"].toString(), resLocation[i]["preferredImage"]["uri"], getTheaterGenre(resLocation[i]['genres']), resLocation[i]["runTime"]);
//
//                              listOfFilmsInTheaters.add(newFilm);
//
//                              //List theaterGenresFixed = getTheaterGenre(resLocation[i]['genres']);
//                              print(newFilm.theaterFilmGenres());
//                              print("Length: " + newFilm.theaterFilmLength().toString());
//
//                            }
//                            print("Number of films: " + listOfFilmsInTheaters.length.toString());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyDiscoverPage(
                                        uid: widget.uid,
                                        theaterMovies: listOfFilmsInTheaters,
                                      )),
                            );
                          },
                          child: Text(
                            "NEW SEARCH",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () async {
                            var genreMap = Map();
                            print("Search by preferences activated.");
                            print("List length: " +
                                faveFilmsList.length.toString());
                            totalTime = 0;
                            for (int w = 0; w < faveFilmsList.length; w++) {
                              //print(faveFilmsList[w].getFilmName());
                              //print(faveFilmsList[w].getFilmGenres());

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

                            double averageTime =
                                totalTime / faveFilmsList.length;
                            print("Average time of favorites: " +
                                averageTime.toString());

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

                            var now = new DateTime.now();
                            var currentDate =
                                new DateFormat("yyyy-MM-dd").format(now);
                            String searchPlace =
                                "http://data.tmsapi.com/v1.1/movies/showings?startDate=" +
                                    currentDate.toString() +
                                    "&zip=" +
                                    zipString +
                                    "&api_key=ewgmhk7qeyw8jcwrzspw8k2w";
                            print(searchPlace);
                            //------
                            //var res = await http.get(searchPlace);
                            //var resLocation = jsonDecode(res.body);
                            //listOfFilmsInTheaters = [];

                            for (int i = 0;
                                i < listOfFilmsInTheaters.length;
                                i++) {
                              //print(resLocation[i]["title"]);
                              //searchTheaterList.add(resLocation[i]["title"]);

                              //var newFilm = new theaterMovie(resLocation[i]["title"], resLocation[i]["longDescription"], resLocation[i]["releaseYear"].toString(), resLocation[i]["preferredImage"]["uri"], getTheaterGenre(resLocation[i]['genres']), resLocation[i]["runTime"]);

                              //listOfFilmsInTheaters.add(newFilm);

                              //List theaterGenresFixed = getTheaterGenre(resLocation[i]['genres']);
                              //print(newFilm.theaterFilmGenres());
                              //print("Length: " + newFilm.theaterFilmLength().toString());
                              int count = 0;
                              for (int h = 0; h < genreList.length; h++) {
                                if (listOfFilmsInTheaters[i]
                                    .theaterFilmGenres()
                                    .contains(genreList[h])) {
                                  print(genreList[h] + " is a genre!");
                                  count += pointCount[h];
                                }
                              }

                              listOfFilmsInTheaters[i]
                                  .setGenreMatchCount(count);
                              print(listOfFilmsInTheaters[i].theaterFilmName());
                              print("Total count: " +
                                  listOfFilmsInTheaters[i]
                                      .totalMatch()
                                      .toString());
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
                                      )),
                            );

                            setState(() {});
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                "SEARCH BY",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                "PREFERENCES",
                                style: TextStyle(fontSize: 20.0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

                          padding: EdgeInsets.only(
                              left: 52.5, top: 15.0, right: 52.5, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("Changing theater.");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TheaterFindPage(uid: widget.uid)),
                            );
                          },
                          child: Text(
                            "CHANGE THEATER",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Text(""),
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
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
                                "EDIT YOUR TASTES",
                                style: TextStyle(fontSize: 20.0),
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
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List getTheaterGenre(List genreName) {
    for (int i = 0; i < genreName.length; i++) {
      if (genreName[i] == "Music" || genreName[i] == "Musical comedy") {
        genreName[i] = "Musical";
      } else if (genreName[i] == "Crime drama") {
        genreName[i] = genreName[i];
      } else if (genreName[i] == "Romantic comedy") {
        genreName[i] = "Romance";
      } else if (genreName[i].contains("comedy")) {
        genreName[i] = "Comedy";
      } else if (genreName[i] == "Suspense") {
        genreName[i] = "Thriller";
      } else if (genreName[i] == "Children") {
        genreName[i] = "Family";
      } else if (genreName[i] == "Biography" ||
          genreName[i] == "Historical drama") {
        genreName[i] = "History";
      } else if (genreName[i] == "Anime") {
        genreName[i] = "Animated";
      } else if (genreName[i].contains("drama")) {
        genreName[i] = "Drama";
      } else
        genreName[i] = genreName[i];
    }
    return genreName;
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

  theaterMovie(this.filmName, this.filmPlot, this.filmReleaseDate,
      this.filmPoster, this.filmGenres, this.filmLength) {}

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
}
