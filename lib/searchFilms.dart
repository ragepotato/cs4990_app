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
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Color.fromARGB(255, 76, 187, 204),
        appBar: new AppBar(
          title: new Text("Film Search", style: GoogleFonts.ubuntu()),
          //backgroundColor: Colors.grey,
        ),
        body: new Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(8),
              child: Text("Pick a Film:", style: GoogleFonts.ubuntu(fontSize: 25)),
            ),



            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(6),
                    itemCount: widget.listSearch.length,
                    separatorBuilder: (BuildContext context, int Index) =>
                        Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {

                        return Container(

                          child: Center(
                              child: RaisedButton(
                                //color: Colors.lightBlueAccent,
                                child: Text(widget.listSearch[Index]['title'],style: GoogleFonts.ubuntu()),
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