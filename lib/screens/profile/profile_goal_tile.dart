import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/profile/edit_goal.dart';
import 'package:thrive/screens/profile/edit_goal_progress.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;

class GoalTile extends StatefulWidget {
  final Goal goal;
  final String id;
  final Function updateTile;

  GoalTile({this.goal, this.id, this.updateTile});

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(top: 1.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            leading: CircularPercentIndicator(
                radius: 50,
                animation: true,
                animationDuration: 1200,
                lineWidth: 5.0,
                // indicates progress on goal
                percent: (double.parse(widget.goal.goalProgress) /
                    double.parse(widget.goal.goalUnits)),
                center: new Text(
                  widget.goal.goalUnits,
                  style: new TextStyle(
                    fontFamily: 'proxima',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: ThriveColors.DARK_GREEN,
                  ),
                ),
                backgroundColor: ThriveColors.DARK_GREEN,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: ThriveColors.DARK_ORANGE),
            title: Text(
              widget.goal.goal,
              style: new TextStyle(
                  fontFamily: 'proxima',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            subtitle: Text(widget.goal.goalDate),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EditGoalProgress(
                    goal: widget.goal,
                    id: widget.id,
                    updateTile: widget.updateTile),
                EditGoal(
                    goal: widget.goal,
                    id: widget.id,
                    updateTile: widget.updateTile)
              ],
            ),
          ),
          color: Color(0xFFF0FFED),
        ));
  }
}
