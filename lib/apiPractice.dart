import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class apiPage extends StatefulWidget {
  @override
  _apiPageState createState() => _apiPageState();
}

class _apiPageState extends State<apiPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MultiSelect Formfield Example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text('Summary: '),
              onPressed: _getSummary,
            ),
          ],
        ),
      ),
    );
  }

  void _getSummary() {
    print("Start the request...");
    http
        .get(
            "https://api.themoviedb.org/3/movie/105?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US")
        .then((res) {
      print("received response.");
      print(res.statusCode);
      var resSummary = jsonDecode(res.body);
      String printSummary = resSummary['overview'];
      print([printSummary]);
      //print(res.body);
    }).catchError((e) {
      print('Failed');
    });
  }
}
