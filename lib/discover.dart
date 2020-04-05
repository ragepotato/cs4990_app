//import 'dart:js';

import 'package:cs4990_app/genreSearch.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'main.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'genreSearch.dart';
import 'searchResults.dart';

class MyDiscoverPage extends StatefulWidget {
  MyDiscoverPage({Key key, this.title, this.uid, this.theaterMovies})
      : super(key: key);
  final String uid;
  final String title;
  List theaterMovies;

  @override
  _MyDiscoverState createState() => _MyDiscoverState();
}
//enum WhyFarther { bool harder, smarter, selfStarter, tradingCharter}

class _MyDiscoverState extends State<MyDiscoverPage> {
  final formKey = new GlobalKey<FormState>();

  @override
  String dropdownValues = 'G';
  String filmLength = '< 90 mins';
  @override
  int _selection;
  double acclaimSlider = 1;
  double popularitySlider = 1;
  var num2;
  var genreSearchList = [];
  String genreText = "Genres: ";
  var theaterFilms = [];

  void initState() {
    super.initState();
    theaterFilms = widget.theaterMovies;
    print("Number of movies in theaters: " + theaterFilms.length.toString());
  }

  //create an array of booleans to determine what is being checked off
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        backgroundColor: Colors.pinkAccent,
        // body: new Stack(

        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[



                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.only(top: 36, bottom: 8),
                    child: Text(
                      'What to Watch?',
                      style: TextStyle(
                        fontSize: 30.0, // insert your font size here
                      ),
                    ),
                  ),
                ),

                Expanded(
                    flex: 15,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          child: Text(genreText),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: FlatButton(
                            textColor: Colors.black,
                            color: Colors.white,
                            child: Text("Pick Genres"),
                            onPressed: () async {
                              print(genreSearchList);

                              //if (genreSearchList.isNotEmpty){
                              genreSearchList = await Navigator.push(
                                  ctxt,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new GenreSearchPage(
                                      myGenreList: genreSearchList,
                                    ),
                                    fullscreenDialog: true,
                                  ));
                              setState(() {
                                genreText = "Genres: ";
                                if (genreSearchList.isNotEmpty) {
                                  for (int w = 0;
                                      w < genreSearchList.length - 1;
                                      w++) {
                                    genreText += (genreSearchList[w] + ", ");
                                  }
                                  genreText += genreSearchList[
                                      genreSearchList.length - 1];
                                }
                              });
                              //}
                            },
                          ),
                        ),
                      ],
                    )),



                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Highest MPAA Rating? ',
                          style: TextStyle(
                            fontSize: 15.0, // insert your font size here
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: dropdownValues,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValues = newValue;
                                });
                              },
                              items: [
                                'G',
                                'PG',
                                'PG-13',
                                'R',
                                'doesn\'t matter'
                              ].map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    color: Colors.pinkAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Preferred Film Length? ',
                          style: TextStyle(
                            fontSize: 20.0, // insert your font size here
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: filmLength,
                              isDense: true,
                              onChanged: (String anotherValue) {
                                setState(() {
                                  filmLength = anotherValue;
                                });
                              },
                              items: [
                                '< 90 mins',
                                '< 120 mins',
                                '< 150 mins',
                                'doesn\'t matter',
                              ].map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Text(
                  "How much do you care about a film's... ",
                  style: TextStyle(
                    fontSize: 15.0, // insert your font size here
                  ),
                ),

                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Acclaim?",
                        style: TextStyle(
                          fontSize: 20.0, // insert your font size here
                        ),
                      ),
                      Slider(
                        //label: 'acclaim',
                        value: acclaimSlider,
                        onChanged: (double accAmount) {
                          setState(() {
                            acclaimSlider = accAmount;
                          });
                        },
                        min: 1,
                        max: 5,
                        divisions: 4,
                      ),
                      Text(
                          // double num2 = double.parse(num1.toStringAsFixed(2));

                          acclaimSlider.round().toString())
                    ],
                  ),
                ),

                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Popularity?",
                        style: TextStyle(
                          fontSize: 20.0, // insert your font size here
                        ),
                      ),
                      Slider(
                        //label: 'acclaim',
                        value: popularitySlider,
                        onChanged: (double popAmount) {
                          setState(() {
                            popularitySlider = popAmount;
                            popularitySlider.round();
                          });
                        },
                        min: 1,
                        max: 5,
                        divisions: 4,
                      ),
                      Text(
                          // double num2 = double.parse(num1.toStringAsFixed(2));

                          popularitySlider.round().toString())
                    ],
                  ),
                ),

                Expanded(
                  flex: 13,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      //padding: EdgeInsets.all(16.0),

//                padding: EdgeInsets.only(
//                    left: 52.5, top: 15.0, right: 52.5, bottom: 15.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () {







                        //_saveForm();
                        print('-----------------------------------');
                        //print(_myActivitiesResult);
                        print(dropdownValues);

                        print(filmLength);
                        print("How much they care about acclaim: " +
                            '$acclaimSlider');
                        print("How much they care about popularity: " +
                            '$popularitySlider');




                        print(theaterFilms.length);
                        for (int h = 0; h < theaterFilms.length; h++) {
                          List theMatches = [];
                          int totalPossible = 0;
                          print(theaterFilms[h].theaterFilmName());
                          int count = 0;

                          if (double.parse(theaterFilms[h].theaterScore()) >= 7.0){
                            count += (acclaimSlider.round() - 1);

                            print("Because of acclaim: +" + (acclaimSlider.round() - 1).toString());
                          }
                          totalPossible += (acclaimSlider.round() - 1);

                          if (dropdownValues == 'G') {
                            if (theaterFilms[h].theaterFilmRating() == 'G') {
                              count += 3;
                              print("G or less! +3");
                            }
                          } else if (dropdownValues == 'PG') {
                            if (theaterFilms[h].theaterFilmRating() == 'G' || theaterFilms[h].theaterFilmRating() == 'PG') {
                              count += 3;
                              print("PG or less! +3");
                            }
                          } else if (dropdownValues == 'PG-13') {
                            if (theaterFilms[h].theaterFilmRating() == 'G' || theaterFilms[h].theaterFilmRating() == 'PG' || theaterFilms[h].theaterFilmRating() == 'PG-13' ) {
                              count += 3;
                              print("PG-13 or less! +3");
                            }
                          }
                          else if (dropdownValues == 'R') {
                            if (theaterFilms[h].theaterFilmRating() == 'G' || theaterFilms[h].theaterFilmRating() == 'PG' || theaterFilms[h].theaterFilmRating() == 'PG-13' || theaterFilms[h].theaterFilmRating() == 'R') {
                              count += 3;
                              print("R or less! +3");
                            }
                          }

                          else {}
                        totalPossible +=3;
                          if (filmLength == '< 90 mins') {
                            if (theaterFilms[h].theaterFilmLength() <= 90) {
                              count += 2;
                              print("Less than 90 mins! +2");
                            }
                          } else if (filmLength == '< 120 mins') {
                            if (theaterFilms[h].theaterFilmLength() <= 120) {
                              count += 2;
                              print("Less than 120 mins! +2");
                            }
                          } else if (filmLength == '< 150 mins') {
                            if (theaterFilms[h].theaterFilmLength() <= 150) {
                              count += 2;
                              print("Less than 150 mins! +2");
                            }
                          } else {}
                        totalPossible +=2;


                          totalPossible += genreSearchList.length*2;
                          for (int j = 0; j < genreSearchList.length; j++) {

                            if (theaterFilms[h]
                                .theaterFilmGenres()
                                .contains(genreSearchList[j])) {
                              print(genreSearchList[j] + " is a genre! +2");
                              count += 2;
                              theMatches.add(genreSearchList[j]);
                            }
                          }
                          theaterFilms[h].setGenreMatchCount(count);
                          theaterFilms[h].getTotalPossible(totalPossible);

                          print("Total count: " +
                              theaterFilms[h].totalMatch().toString());

                          print("Total possible: " + totalPossible.toString());

                          theaterFilms[h].genresThatMatch(theMatches);
                          print(theaterFilms[h].getGenreResults());
                        }

                        theaterFilms.sort(
                            (a, b) => b.totalMatch().compareTo(a.totalMatch()));
                        print("Highest match: " +
                            theaterFilms[0].theaterFilmName());

                        print(genreSearchList);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                    uid: widget.uid,
                                    listMatches: theaterFilms,
                                isSearchPreferences: 2,
                                  )),
                        );

                        //Navigator.pop(context);
                      },
                      child: Text(
                        "SEARCH!",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
//              Container(
//                padding: EdgeInsets.all(8),
//                child: RaisedButton(
//                  child: Text('Save'),
//                  onPressed: _saveForm,
//                ),
//              ),
//                Container(
//                  padding: EdgeInsets.all(16),
//                  child: Text(_myActivitiesResult),
//                ),
              ],
            ),
          ),
        ));
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
