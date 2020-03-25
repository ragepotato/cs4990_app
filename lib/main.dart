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

  _MyHomePageState() {
    // var faveFilmsList = List<filmMovie>();



    _auth.currentUser().then((user) {
      currentUser = user.uid;
      ref.child(currentUser + "/location/zipCode").once().then((ds) {
        zipString = ds.value;
      }).catchError((e) {
        print("None available for " + currentUser + " --- " + e.toString());
      });
      ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds) {
        ds.value.forEach((k, v) {
//                                  movieTitle = k;
//                                  movieDate = v['releaseYear'];
//                                  movieSummary = v['summary'];
//                                  moviePosterLink = v['posterPath'];

          //movieGenres = (v['genres']);
          var theFilm = new filmMovie(
              k, v['summary'], v['releaseYear'], v['posterPath'], v['genres']);
          faveFilmsList.add(theFilm);
        });
        setState(() {
          print("Length: " + faveFilmsList.length.toString());
        });
      }).catchError((e) {
        print("None available for " + currentUser + " --- " + e.toString());
      });
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
                image: new AssetImage("lalaland1.jpg"),
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
                          onPressed: () {
                            print("New Search activated.");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyDiscoverPage(uid: widget.uid)),
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
                          onPressed: () async{
                            var genreMap = Map();
                            print("Search by preferences activated.");
                            print("List length: " +
                                faveFilmsList.length.toString());
                            for (int w = 0; w < faveFilmsList.length; w++) {
                              //print(faveFilmsList[w].getFilmName());
                              //print(faveFilmsList[w].getFilmGenres());
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

                            var sortedKeys = genreMap.keys
                                .toList(growable: false)
                                  ..sort((k1, k2) =>
                                      genreMap[k2].compareTo(genreMap[k1]));
                            LinkedHashMap sortedMap =
                                new LinkedHashMap.fromIterable(sortedKeys,
                                    key: (k) => k, value: (k) => genreMap[k]);
                            var genreList = sortedMap.keys.toList();
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
                            var res = await http.get(searchPlace);
                            var resLocation = jsonDecode(res.body);
                            for (int i = 0; i < resLocation.length; i++) {
                              print(resLocation[i]["title"]);
                              //searchTheaterList.add(resLocation[i]["title"]);


                              for(int j = 0; j < resLocation[i]['genres'].length; j++){
                                //print(resLocation[i]['genres'][j]);
                                print("-" + getTheaterGenre(resLocation[i]['genres'][j]));
                              }



                            }

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
  String getTheaterGenre(String genreName){
    if (genreName == "Music" || genreName == "Musical comedy"){
      return "Musical";
    }
    if (genreName == "Crime drama"){
      return genreName;
    }
    if (genreName == "Romantic comedy"){
      return "Romance";
    }
    if (genreName.contains("comedy")){
      return "Comedy";
    }
    if (genreName == "Suspense"){
      return "Thriller";
    }
    if (genreName == "Children"){
      return "Family";
    }

    if (genreName == "Biography" || genreName == "Historical drama"){
      return "History";
    }

    if (genreName == "Anime"){
      return "Animated";
    }
    if (genreName.contains("drama")){
      return "Drama";
    }
    return genreName;
  }




}
