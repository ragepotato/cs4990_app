import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'dart:ui';
import 'main.dart';

class FavoritesPage extends StatefulWidget {
  //FavoritesPage({Key key, this.title}) : super(key: key);
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  int counter = 1;
  List<String> litems = [];

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
                });
              },
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: litems.length,
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
                        child: new ListTile(
                          leading: Icon(Icons.laptop_chromebook),
                          title: Text(
                              (counter++).toString() + '. ' + litems[Index]),
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
}

//class _FavoritesState extends State<FavoritesPage> {
//
//
//  @override
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('MultiSelect Formfield Example'),
//      ),
//      body:
//            //getListView(),
//      );
//  }
//
//
//
//
////  Widget getListView() {
////    int counter = 0;
////    var listView = ListView(
////      children: <Widget>[
////
////        ListTile(
////          leading: Icon(Icons.landscape),
////          title: Text("Landscape"),
////          subtitle: Text("Beautiful View !"),
////          trailing: Icon(Icons.wb_sunny),
////          onTap: () {
////            debugPrint("Landscape tapped");
////          },
////        ),
////
//        ListTile(
//          leading: Icon(Icons.laptop_chromebook),
//          title: Text("Windows"),
//        ),
////
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
////        ListTile(
////          leading: Icon(Icons.phone),
////          title: Text("Phone " + (counter++).toString()),
////        ),
//////      Text("Yet another element in List"),
////
//////      Container(color: Colors.red, height: 50.0,)
////
////      ],
////    );
////
////    return listView;
////  }
//
//
//}
