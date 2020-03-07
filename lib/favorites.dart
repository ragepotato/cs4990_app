import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final String apiKey = '45d251111f5b70015f4cc65e2b92d0d1';
  var currentUser = "Unknown";

  _FavoritesState(){
    _auth.currentUser().then((user){


      currentUser = user.uid;

      ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds){


        ds.value.forEach((k, v){
          print(k);
          print(v['summary']);
        });
      }).catchError((e){
        print("None available for " + currentUser + " --- " + e.toString());
      });




      setState(() {


      });
    }).catchError((e){
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

              //maybe put a flatbutton search onPressed()
//              onSubmitted: (text) async{
//
//              },
            ),
            FlatButton(child:Text("SEARCH"),
                onPressed: () async{
                  String linkText = eCtrl.text.replaceAll(' ', '%20');
                  String sumText = 'https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=' + linkText + '&page=1&include_adult=false';
                  print(sumText);
                  var res = await http.get(sumText);
                  var resSummary = jsonDecode(res.body);
                  //if (resSummary)
                  int howMany = resSummary['total_results'];
                  print(howMany);
                  movieTitle = resSummary['results'][0]['title'];
                  movieSummary = resSummary['results'][0]['overview'];
                  movieDate = resSummary['results'][0]['release_date'];

                  print("Here.");
                  ref.child(currentUser + "/favoriteMovies/filmName/" + movieTitle).set(
                    {
                      "releaseYear" : resSummary['results'][0]['release_date'].substring(0, resSummary['results'][0]['release_date'].indexOf('-')),
                      "summary" : resSummary['results'][0]['overview'],
                    }
                  ).then((res){
                      print("Movie is added to database.");
                    }).catchError((e){
                      print("Failed due to " + e);
                  });

                  ref.child(currentUser + "/favoriteMovies/filmName").once().then((ds){
                    print(ds.value);

                    ds.value.forEach((k, v){
                      print(k);
                      print(v);
                    });


                  }).catchError((e){
                    print("None available for " + currentUser + " --- " + e.toString());
                  });





                  var theFilm = new filmMovie(movieTitle, movieSummary, movieDate);
                  movieSummary = theFilm.getSummary();
//                print(theFilm.getFilmName());
//                print(theFilm.getSummary());
                  litems.add(theFilm);
                  eCtrl.clear();

                  setState(() {
                    counter = 1;
                  });
                }
            ),

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
                            litems.removeAt(Index);
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
                                  "https://filmschoolrejects.com/wp-content/uploads/2017/04/1irbHjhl9Yezn550CmdHrNA.jpeg"),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
//                                onPressed: (){
//                                  setState(() {
//
//                                  });
//                                },
                            ),
                            title: Text(
                                (Index + 1).toString() + '. ' + litems[Index].getFilmName() + " (" + litems[Index].getReleaseYear() + ")"),

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

  filmMovie(this.filmName, this.filmPlot, this.filmReleaseDate){
  }


  String getFilmName(){
    return filmName;
  }


  String getSummary() {
      return filmPlot;
  }

  String getReleaseYear(){
    return filmReleaseDate.substring(0, filmReleaseDate.indexOf('-'));
  }


}
