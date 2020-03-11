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

class SearchFilmPage extends StatefulWidget {
  SearchFilmPage({Key key, this.listSearch} ) : super(key: key);
    final List listSearch;


  @override
  _SearchFilmState createState() => _SearchFilmState();
}

class _SearchFilmState extends State<SearchFilmPage> {


  _SearchFilmState(){

}


  final TextEditingController eCtrl = new TextEditingController();

  int searchChoice = 0;

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Hello"),
        ),
        body: new Column(
          children: <Widget>[

            FlatButton(
                child: Text("SEARCH"),),


            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.listSearch.length,
                    separatorBuilder: (BuildContext context, int Index) =>
                        Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {

                        return Container(

                          child: Center(
                              child: FlatButton(
                                color: Colors.lightBlueAccent,
                                child: Text(widget.listSearch[Index]['title'],),
                                onPressed: (){
                                  print(widget.listSearch[Index]['title']);

                                  Navigator.pop(context, Index);
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(builder: (context) => FavoritesPage(searchIndex: searchChoice,)),);
//
                                },
                              )

                          ),

                        );
                    }))
          ],
        ));
  }





}