import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrive/models/goal.dart';
import 'package:thrive/screens/profile/edit_goal.dart';
import 'package:thrive/screens/profile/edit_goal_progress.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thrive/formats/colors.dart' as ThriveColors;
import 'package:thrive/formats/fonts.dart' as ThriveFonts;

class GoalTile extends StatefulWidget {
  final Goal goal;
  final String id;
  final String collabs;
  final Function updateTile;

  GoalTile({this.goal, this.id, this.collabs, this.updateTile});

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  @override
  Widget build(BuildContext context) {
    DateTime realDate = DateTime.parse(widget.goal.goalDate);
    DateTime now = new DateTime.now();
    DateTime todayDate = new DateTime(now.year, now.month, now.day);
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(2.0),
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
                widget.goal.goalUnits.length >= 3
                    ? widget.goal.goalProgress + "/\n" + widget.goal.goalUnits
                    : widget.goal.goalProgress + "/" + widget.goal.goalUnits,
                style: new TextStyle(
                  fontFamily: 'proxima',
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: ThriveColors.DARK_GREEN,
                ),
              ),
              backgroundColor: ThriveColors.DARK_GREEN,
              circularStrokeCap: CircularStrokeCap.round,
              // progressColor: ThriveColors.LIGHT_GREEN
              progressColor: ThriveColors.LIGHT_ORANGE),
          title: Text(
            widget.goal.goal,
            style: new TextStyle(
              fontFamily: 'proxima',
              // fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: realDate.isBefore(todayDate)
                  ? ThriveColors.LIGHT_ORANGE
                  : ThriveColors.LIGHTEST_GREEN,
            ),
          ),
          subtitle: Text(
            widget.goal.goalDate,
            style: new TextStyle(
              color: realDate.isBefore(todayDate)
                  ? ThriveColors.DARK_ORANGE
                  : ThriveColors.DARK_GREEN,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //EditGoalProgress(
              //    goal: widget.goal,
              //    id: widget.id,
              //    updateTile: widget.updateTile),
              // SizedBox(width: 50),
              EditGoal(
                  goal: widget.goal,
                  id: widget.id,
                  collabs: widget.collabs,
                  updateTile: widget.updateTile)
            ],
          ),
        ));
  }
}
