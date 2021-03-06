import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/services/database.dart';
import 'package:thrive/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class EditGoal extends StatefulWidget {
  final Goal goal;
  final String id;
  final String collabs;
  final Function updateTile;

  EditGoal({this.goal, this.id, this.collabs, this.updateTile});

  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  var repeatText = TextEditingController();
  String _selectedRepeat = "Don't Repeat";

  String goal_name = '';

  String goalUnits = '';

  String goalDate = '';

  String goalRepeat = '';

  String goalProgress = '';

  String _goalDeadline = '';

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    goal_name = widget.goal.goal;
    goalUnits = widget.goal.goalUnits;
    goalDate = widget.goal.goalDate;
    goalRepeat = widget.goal.goalRepeat;
    goalProgress = widget.goal.goalProgress;
    _goalDeadline = goalDate;
    var dateText = TextEditingController(text: goalDate);

    return IconButton(
      icon: Icon(Icons.edit, color: ThriveColors.LIGHT_ORANGE),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              String _selectedRepeat = goalRepeat;
              String _goalDeadline = goalDate;
              return StatefulBuilder(builder: (context, setState) {
                return new AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    backgroundColor: ThriveColors.DARK_GREEN,
                    title: Center(
                        child: new Text(
                      'Edit Goal',
                      style: ThriveFonts.HEADING,
                    )),
                    content: new Container(
                        width: 400,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  TextFormField(
                                    initialValue: goal_name,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please set a name for your goal";
                                      }
                                      goal_name = value;
                                      return null;
                                    },
                                    style: ThriveFonts.BODY_WHITE,
                                    decoration: new InputDecoration(
                                        hintText: "Goal Name"),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    initialValue: goalUnits,
                                    validator: (value) {
                                      goalUnits = value;
                                      return null;
                                    },
                                    style: ThriveFonts.BODY_WHITE,
                                    decoration: new InputDecoration(
                                        hintText: "How Many Units(Optional)"),
                                  ),
                                  SizedBox(height: 20.0),
                                  InkWell(
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2018),
                                                lastDate: DateTime.now()
                                                    .add(Duration(days: 365)))
                                            .then((date) {
                                          setState(() {
                                            _goalDeadline =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date);
                                            dateText.text = _goalDeadline;
                                            //_goalDeadline = goalDate;
                                          });
                                        });
                                      },
                                      child: IgnorePointer(
                                          child: new TextFormField(
                                        decoration: new InputDecoration(
                                            hintText: "Goal Deadline"),
                                        controller: dateText,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please set a deadline for your goal";
                                          }
                                          goalDate = value;
                                          _goalDeadline = value;
                                          return null;
                                        },
                                        style: ThriveFonts.BODY_WHITE,
                                      ))),
                                  SizedBox(height: 20.0),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        canvasColor: ThriveColors.BLACK,
                                        buttonColor: ThriveColors.BLACK),
                                    child: DropdownButton<String>(
                                      hint: Text("Repeat"),
                                      style: ThriveFonts.SUBHEADING_WHITE,
                                      focusColor: ThriveColors.LIGHT_GREEN,
                                      value: _selectedRepeat,
                                      items: <String>[
                                        "Don't Repeat",
                                        "Repeat Every Day",
                                        "Repeat Every Week",
                                        "Repeat Every Month",
                                        "Repeat Every Year"
                                      ].map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedRepeat = value;
                                          goalRepeat = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  RaisedButton(
                                      child: Text("Submit changes"),
                                      color: ThriveColors.LIGHTEST_GREEN,
                                      onPressed: () {
                                        if (_formkey.currentState.validate()) {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                new AlertDialog(
                                              title: new Text('Submit Changes'),
                                              content: new Text(
                                                  'Do you want to edit this goal?'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: new Text('No'),
                                                ),
                                                new FlatButton(
                                                  // TODO: Process data and make http request
                                                  onPressed: () async {
                                                    //hashing
                                                    FirebaseUser result =
                                                        await _auth
                                                            .getCurrentUser();

                                                    // If there is a current user logged in, make HTTP request
                                                    if (result != null) {
                                                      _db.postGoal(
                                                          goal_name,
                                                          widget.id,
                                                          goalUnits,
                                                          goalDate,
                                                          goalRepeat,
                                                          goalProgress);
                                                      widget.updateTile();
                                                    }
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                  child: new Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                  SizedBox(height: 50.0),
                                  RaisedButton(
                                    child: Text('Delete goal'),
                                    onPressed: () {
                                      if (_formkey.currentState.validate()) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => new AlertDialog(
                                            title: new Text('Delete Goal'),
                                            content: new Text(
                                                'Are you sure you want to delete this goal?'),
                                            actions: <Widget>[
                                              new FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: new Text('No'),
                                              ),
                                              new FlatButton(
                                                // TODO: Process data and make http request
                                                onPressed: () async {
                                                  //hashing
                                                  FirebaseUser result =
                                                      await _auth
                                                          .getCurrentUser();

                                                  // If there is a current user logged in, make HTTP request
                                                  if (result != null) {
                                                    String username =
                                                        await _db.getUsername(
                                                            result.uid);
                                                    bool finished =
                                                        await _db.deleteGoal(
                                                            username,
                                                            widget.id);

                                                    String collabStr =
                                                        widget.collabs;

                                                    while (
                                                        collabStr.length != 0) {
                                                      int commaIdx = collabStr
                                                          .indexOf(",");
                                                      String username = '';
                                                      if (commaIdx != -1) {
                                                        username =
                                                            collabStr.substring(
                                                                0, commaIdx);
                                                        collabStr =
                                                            collabStr.substring(
                                                                commaIdx + 2);
                                                      } else {
                                                        username = collabStr;
                                                        collabStr = '';
                                                      }

                                                      _db.deleteGoal(
                                                          username, widget.id);
                                                    }
                                                    if (finished) {
                                                      widget.updateTile();
                                                    }
                                                  }

                                                  Navigator.of(context)
                                                      .pop(true);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                },
                                                child: new Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    color: ThriveColors.DARK_ORANGE,
                                  )
                                ],
                              )),
                        )));
              });
            });
      },
    );
  }
}
