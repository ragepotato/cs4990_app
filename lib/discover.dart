//import 'dart:js';

import 'package:cs4990_app/genreSearch.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String acclaimString = "";

  void initState() {
    super.initState();
    theaterFilms = widget.theaterMovies;
    print("Number of movies in theaters: " + theaterFilms.length.toString());
  }

  //create an array of booleans to determine what is being checked off
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        backgroundColor: Color.fromARGB(255, 76, 187, 204),
        // body: new Stack(

        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex:18,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //padding: EdgeInsets.only(top: 36, bottom: 8),
                      Text(
                        'What to Watch?',
                        style: GoogleFonts.ubuntu(
                          fontSize: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.only(top: 30),
                            child: Text(
                              '1) Choose your genres. ',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            //padding: EdgeInsets.only(top: 40),
                            child: RaisedButton(
                              elevation: 10,
                              textColor: Colors.black,
                              //color: Colors.white,
                              child: Text(
                                "Pick Genres",
                                style: GoogleFonts.ubuntu(),
                              ),
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
                      ),
                      Align(

                        child: Container(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: Text(
                            genreText,
                            style: GoogleFonts.ubuntu(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '2) Highest MPAA Rating? ',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              color: Colors.white,
                              child: DropdownButtonHideUnderline(
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
                                        child: Text(
                                          value,
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '3) Preferred Film Length? ',
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              color: Colors.white,
                              child: DropdownButtonHideUnderline(
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
                                        child: Text(
                                          value,
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                        "4) Finally, on a scale on 1-5, how much do you care about a film's critical acclaim?",
                        style: GoogleFonts.ubuntu(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            acclaimString,
                            style: GoogleFonts.ubuntu(fontSize: 20.0),
                          ),
                          Slider(
                            activeColor: Colors.white,

                            //label: 'acclaim',
                            value: acclaimSlider,
                            onChanged: (double accAmount) {
                              setState(() {
                                acclaimSlider = accAmount;
                                //print(acclaimSlider);
                                if (acclaimSlider == 1.0) {
                                  acclaimString = "Not at all";
                                }
                                if (acclaimSlider == 2.0) {
                                  acclaimString = "Not much";
                                }
                                if (acclaimSlider == 3.0) {
                                  acclaimString = "Kind of";
                                }
                                if (acclaimSlider == 4.0) {
                                  acclaimString = "Important";
                                }
                                if (acclaimSlider == 5.0) {
                                  acclaimString = "Necessity";
                                }
                              });
                            },
                            min: 1,
                            max: 5,
                            divisions: 4,
                          ),
                          Text(
                            // double num2 = double.parse(num1.toStringAsFixed(2));

                            acclaimSlider.round().toString(),
                            style: GoogleFonts.ubuntu(fontSize: 20.0),
                          )
                        ],
                      ),
                      Container(
                        //padding: EdgeInsets.all(12),
                        child: RaisedButton(

                          elevation: 8,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(16.0),

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

                              if (double.parse(
                                      theaterFilms[h].theaterScore()) >=
                                  7.0) {
                                count += (acclaimSlider.round() - 1);

                                print("Because of acclaim: +" +
                                    (acclaimSlider.round() - 1).toString());
                              }
                              totalPossible += (acclaimSlider.round() - 1);

                              if (dropdownValues == 'G') {
                                if (theaterFilms[h].theaterFilmRating() ==
                                    'G') {
                                  count += 3;
                                  print("G or less! +3");
                                }
                              } else if (dropdownValues == 'PG') {
                                if (theaterFilms[h].theaterFilmRating() ==
                                        'G' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'PG') {
                                  count += 3;
                                  print("PG or less! +3");
                                }
                              } else if (dropdownValues == 'PG-13') {
                                if (theaterFilms[h].theaterFilmRating() ==
                                        'G' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'PG' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'PG-13') {
                                  count += 3;
                                  print("PG-13 or less! +3");
                                }
                              } else if (dropdownValues == 'R') {
                                if (theaterFilms[h].theaterFilmRating() ==
                                        'G' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'PG' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'PG-13' ||
                                    theaterFilms[h].theaterFilmRating() ==
                                        'R') {
                                  count += 3;
                                  print("R or less! +3");
                                }
                              } else {}
                              totalPossible += 3;
                              if (filmLength == '< 90 mins') {
                                if (theaterFilms[h].theaterFilmLength() <= 90) {
                                  count += 2;
                                  print("Less than 90 mins! +2");
                                }
                              } else if (filmLength == '< 120 mins') {
                                if (theaterFilms[h].theaterFilmLength() <=
                                    120) {
                                  count += 2;
                                  print("Less than 120 mins! +2");
                                }
                              } else if (filmLength == '< 150 mins') {
                                if (theaterFilms[h].theaterFilmLength() <=
                                    150) {
                                  count += 2;
                                  print("Less than 150 mins! +2");
                                }
                              } else {}
                              totalPossible += 2;

                              totalPossible += genreSearchList.length * 2;
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

                              print("Total possible: " +
                                  totalPossible.toString());

                              theaterFilms[h].genresThatMatch(theMatches);
                              print(theaterFilms[h].getGenreResults());
                            }

                            theaterFilms.sort((a, b) =>
                                b.totalMatch().compareTo(a.totalMatch()));
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
                            "Search!",
                            style: GoogleFonts.ubuntu(
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
