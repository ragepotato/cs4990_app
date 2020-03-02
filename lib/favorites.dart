import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  //FavoritesPage({Key key, this.title}) : super(key: key);
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  int counter = 1;
  var litems = List<filmMovie>();
  //List<filmMovie> litems = [];
  String movieSummary = 'n/a';
  final String apiKey = '45d251111f5b70015f4cc65e2b92d0d1';

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Dynamic Demo"),
        ),
        body: new Column(
          children: <Widget>[
            new TextField(
              controller: eCtrl,
              onSubmitted: (text) async{
                String linkText = text.replaceAll(' ', '%20');
                String sumText = 'https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=' + linkText + '&page=1&include_adult=false';
                print(sumText);
                var res = await http.get(sumText);
                print("Okay");
                var resSummary = jsonDecode(res.body);
                print("Okay2");
                movieSummary = resSummary['results'][0]['overview'];
                print("Okay3");
                var theFilm = new filmMovie(text, movieSummary);

                print("Okay4");
                movieSummary = theFilm.getSummary();
                print("Okay5");
                print(theFilm.getFilmName());
                print(theFilm.getSummary());
                litems.add(theFilm);
                print("Okay6");
                eCtrl.clear();

                setState(() {
                  counter = 1;
                  print("heres");
                  print(linkText);
                  print("Summary: " + movieSummary);
                  print ("wowza");
                });
              },
            ),
            Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: litems.length,
                    separatorBuilder: (BuildContext context, int Index) =>
                        Divider(),
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return Dismissible(
                        key: Key(litems[Index].filmName),
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
                                (Index + 1).toString() + '. ' + litems[Index].getFilmName()),

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

  filmMovie(this.filmName, this.filmPlot){
    //setSummary();
  }

  void setSummary() async{
//    print(_filmName);
//    //print("Start the request.....");
//    String sumText = 'https://api.themoviedb.org/3/search/movie?api_key=45d251111f5b70015f4cc65e2b92d0d1&language=en-US&query=' + _filmName + '&page=1&include_adult=false';
//    print(sumText);
//
//    var res = await http.get(sumText);
//    print(res.statusCode);
//    var resSummary = jsonDecode(res.body);
//    print("Got here");
//    print(resSummary['results'][0]['overview']);
//    _filmName = resSummary['results'][0]['overview'];


//    await http.get(sumText).then((res){
//      print(res.statusCode);
//
//    }).catchError((e){
//      print("Error.");
//    });
  }

  String getFilmName(){
    return filmName;
  }


  String getSummary() {
      return filmPlot;

  }
}
