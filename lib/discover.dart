import 'package:flutter/material.dart';
import 'dart:ui';
import 'main.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class MyDiscoverPage extends StatefulWidget {
  MyDiscoverPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyDiscoverState createState() => _MyDiscoverState();
}
//enum WhyFarther { bool harder, smarter, selfStarter, tradingCharter}

enum SingingCharacter { lafayette, jefferson }

// ...

SingingCharacter _character = SingingCharacter.lafayette;

class _MyDiscoverState extends State<MyDiscoverPage> {
  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();
      });
    }
  }

  String dropdownValues = 'G';
  String filmLength = '< 90 mins';
  @override
//  bool selectVal = false;
//  bool selectVal2 = false;
//  bool _selectVal2 = false;
//  bool _firstValue = false;
//  bool _secValue = false;
  List<bool> genreList = new List(8);
  int _selection;
  double acclaimSlider = 1;
  double popularitySlider = 1;
  var num2;

  //create an array of booleans to determine what is being checked off

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent,
        // body: new Stack(

        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: EdgeInsets.only(top: 36, bottom: 12),
                    child: Text(
                      'What to Watch?',
                      style: TextStyle(
                        fontSize: 30.0, // insert your font size here
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Container(
                    padding: EdgeInsets.all(9),
                    child: Container(
                      color: Colors.white,
                      child: MultiSelectFormField(
                        autovalidate: false,
                        //titleText: 'My workouts',
                        titleText: 'Genre',

                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                        },
                        dataSource: [
                          {
                            "display": "Action",
                            "value": "Action",
                          },
                          {
                            "display": "Comedy",
                            "value": "Comedy",
                          },
                          {
                            "display": "Drama",
                            "value": "Drama",
                          },
                          {
                            "display": "Family",
                            "value": "Family",
                          },
                          {
                            "display": "Horror",
                            "value": "Horror",
                          },
                          {
                            "display": "Musical",
                            "value": "Musical",
                          },
                          {
                            "display": "Science Fiction",
                            "value": "Science Fiction",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        // required: true,
                        hintText: 'Please choose one or more',
                        value: _myActivities,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),

//              Container(
//                margin: EdgeInsets.all(16),
//                color: Colors.white,
//                child: Column(
//                  children: <Widget>[
//                    ListTile(
//                      title: const Text(
//                        'Lafayette',
//                        style: TextStyle(
//                          fontSize: 15.0, // insert your font size here
//                        ),
//                      ),
//                      leading: Radio(
//                        value: SingingCharacter.lafayette,
//                        groupValue: _character,
//                        onChanged: (SingingCharacter value) {
//                          setState(() {
//                            _character = value;
//                          });
//                        },
//                      ),
//                    ),
//                    ListTile(
//                      title: const Text('Thomas Jefferson'),
//                      leading: Radio(
//                        value: SingingCharacter.jefferson,
//                        groupValue: _character,
//                        onChanged: (SingingCharacter value) {
//                          setState(() {
//                            _character = value;
//                          });
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
                Expanded(
                  flex: 8,
                  child: Container(
                    color: Colors.pinkAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Highest MPAA Rating? ',
                          style: TextStyle(
                            fontSize: 20.0, // insert your font size here
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
                              items: ['G', 'PG', 'PG-13', 'R', 'NC-17']
                                  .map((String value) {
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
                          'Film Length? ',
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
                                '150 mins'
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
                        max: 10,
                        divisions: 9,
                      ),
                      Text(
                          // double num2 = double.parse(num1.toStringAsFixed(2));

                          '$acclaimSlider')
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
                          });
                        },
                        min: 1,
                        max: 10,
                        divisions: 9,
                      ),
                      Text(
                          // double num2 = double.parse(num1.toStringAsFixed(2));

                          '$popularitySlider')
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
                        _saveForm();
                        print('-----------------------------------');
                        print(_myActivitiesResult);
                        print(dropdownValues);
                        print(filmLength);
                        print("How much they care about acclaim: " +
                            '$acclaimSlider');
                        print("How much they care about popularity: " +
                            '$popularitySlider');
                        Navigator.pop(context);
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
