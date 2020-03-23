import 'package:cs4990_app/theaterFind.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'pulled.dart';
import 'discover.dart';
import 'favorites.dart';
import 'apiPractice.dart';
import 'opening.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //  This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: openingPage(),
      routes: <String, WidgetBuilder>{
        "/DiscoverPage": (BuildContext context) => new MyDiscoverPage(),
        "/FavoritesPage": (BuildContext context) => new FavoritesPage()
      }





    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.uid}) : super(key: key);
  final String uid;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      // body: new Stack(

      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                //image: new AssetImage("Parasite-poster-2.jpg"),
                image: new AssetImage("lalaland1.jpg"),
                //image: new AssetImage("parasite1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0,),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 30,
                  child: Container(
                    //margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            "SeeNext",
                            style:
                                TextStyle(color: Colors.white, fontSize: 60.0),
                          ),
                        ),

                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,

                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

                          padding: EdgeInsets.only(
                              left: 54.0, top: 25.0, right: 54.0, bottom: 25.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("New Search activated.");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyDiscoverPage(uid: widget.uid)),);
                          },
                          child: Text(
                            "NEW SEARCH",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("Search by preferences activated.");
                            setState(() {

                            });

                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                "SEARCH BY",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                "PREFERENCES",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        //Text("Hello"),
                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          //padding: EdgeInsets.all(16.0),

                          padding: EdgeInsets.only(
                              left: 52.5, top: 15.0, right: 52.5, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("Changing theater.");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TheaterFindPage(uid: widget.uid)),);

                          },
                          child: Text(
                            "CHANGE THEATER",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Text(""),
                        FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(
                              left: 50.0, top: 15.0, right: 50.0, bottom: 15.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            print("Search by preferences activated.");
                            print(widget.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FavoritesPage(uid: widget.uid)),);
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                "EDIT YOUR TASTES",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        //Text("Hello"),
                        //Text("Hello"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
