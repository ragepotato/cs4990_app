import 'package:flutter/material.dart';
import 'dart:ui';
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

  @override
  String dropdownValue = "False";

//  bool selectVal = false;
//  bool selectVal2 = false;
//  bool _selectVal2 = false;
//  bool _firstValue = false;
//  bool _secValue = false;
  List<bool> genreList = new List(8);
  int _selection;
  double acclaimSlider = 0;
  var num2;

  //create an array of booleans to determine what is being checked off

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pinkAccent,
        // body: new Stack(

        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
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
              Container(
                margin: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        'Lafayette',
                        style: TextStyle(
                          fontSize: 15.0, // insert your font size here
                        ),
                      ),
                      leading: Radio(
                        value: SingingCharacter.lafayette,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Thomas Jefferson'),
                      leading: Radio(
                        value: SingingCharacter.jefferson,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Text("How much do you care about: "),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Acclaim?"),
                  Slider(
                    label: 'acclaim',
                    value: acclaimSlider,
                    onChanged: (double accAmount) {
                      setState(() {
                        acclaimSlider = accAmount;
                      });
                    },
                  ),
                  Text(
                      // double num2 = double.parse(num1.toStringAsFixed(2));

                      '$acclaimSlider' + '%')
                ],
              ),

//              Container(
//                padding: EdgeInsets.all(8),
//                child: RaisedButton(
//                  child: Text('Save'),
//                  onPressed: _saveForm,
//                ),
//              ),
//              Container(
//                padding: EdgeInsets.all(16),
//                child: Text(_myActivitiesResult),
//              ),
            ],
          ),
        ));
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
