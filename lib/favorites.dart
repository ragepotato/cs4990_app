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
  List<String> litems = [];
  String filmSummary = 'n/a';

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
              onSubmitted: (text) {
                litems.add(text);
                eCtrl.clear();
                setState(() {
                  counter = 1;
                  _getSummary();
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
                        key: Key(litems[Index]),
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
                                (Index + 1).toString() + '. ' + litems[Index]),

                            children: <Widget>[
                              //print(_getSummary());
                              //Text(_getSummary()),
                              Container(
                                padding: EdgeInsets.all(12),
                                child: Text(filmSummary),
                              ),
                            ],
                          ),
                        ),
                      );

//                      return new ListTile(
//                        leading: Icon(Icons.laptop_chromebook),
//                        title:
//                            Text((counter++).toString() + '. ' + litems[Index]),
//                      );
                    }))
          ],
        ));
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
      setState(() {
        filmSummary = resSummary['overview'];
      });
      //print(res.body);
    }).catchError((e) {
      print('Failed');
    });
  }
}
