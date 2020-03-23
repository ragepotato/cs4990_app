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
import 'favorites.dart';
import 'package:intl/intl.dart';

class TheaterFindPage extends StatefulWidget {
  TheaterFindPage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _TheaterFindState createState() => _TheaterFindState();
}

class _TheaterFindState extends State<TheaterFindPage> {
  _TheaterFindState() {}

  final TextEditingController eCtrl = new TextEditingController();
  var searchTheaterList = [];
  int searchChoice = 0;
  var _formKey = GlobalKey<FormState>();
  String zipString = 'SEARCH';

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Hello"),
        ),
        body: new Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  Text("Enter Zip Code:"),
                  TextFormField(
                    controller: eCtrl,
                    decoration: InputDecoration(labelText: " Zip Code"),
                    maxLength: 5,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter something!';
                      }
                      if (value.length < 5){
                        return 'Enter valid zipcode';
                      }
                      return null;
                    },
                  ),
                  FlatButton(
                      child: Text(zipString),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // Process data.
                          var now = new DateTime.now();
                          var currentDate =
                          new DateFormat("yyyy-MM-dd").format(now);
                          String searchPlace =
                              "http://data.tmsapi.com/v1.1/movies/showings?startDate=" +
                                  currentDate.toString() +
                                  "&zip=" +
                                  eCtrl.text +
                                  "&api_key=ewgmhk7qeyw8jcwrzspw8k2w";
                          print(searchPlace);
                          var res = await http.get(searchPlace);
                          var resLocation = jsonDecode(res.body);
                          for (int i = 0; i < resLocation.length; i++) {
                            print(resLocation[i]["title"]);
                            searchTheaterList.add(resLocation[i]["title"]);


                            for(int j = 0; j < resLocation[i]['genres'].length; j++){
                              //print(resLocation[i]['genres'][j]);
                              print("-" + getGenre(resLocation[i]['genres'][j]));
                            }



                          }
                          print(resLocation.length);
                          setState(() {
                            zipString = eCtrl.text;
                          });

                        }



                      }),


                ],
              ),
            ),

            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: searchTheaterList.length,
                    separatorBuilder: (BuildContext context, int Index) =>
                        Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {

                      return Container(

                          child: Center(
                            child: Text(searchTheaterList[Index]),
//

                          )



                      );
                    }))

          ],
        ));
  }

  String getGenre(String genreName){
    if (genreName == "Music" || genreName == "Musical comedy"){
      return "Musical";
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
