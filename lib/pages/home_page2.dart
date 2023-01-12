import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_fab2.dart';
import 'package:habit_tracker/data/habit_database2.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile2.dart';
import '../components/monthly_summary2.dart';
import '../components/my_fab.dart';
import '../components/my_alert_box.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  HabitDatabase2 db = HabitDatabase2();
  final _myBox = Hive.box("Habit_Database2");
  var _isVisible = true;

  late ConfettiController _controller;

  @override
  void initState() {
    // TODO: implement initState
    //checking if there is not current habit

    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }
    //if there is data
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();

    _controller =
        ConfettiController(duration: const Duration(milliseconds: 50));
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();

    if (value == true) {
      _controller.play();
    } else {
      _controller.stop();
    }
  }

  //create a new habit
  final _newHabitNameController = TextEditingController();
  final _EditHabitNameController = TextEditingController();

  void createNewHabit() {
    //show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter New Habit',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  //save new habit
  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //cancel new habit
  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _EditHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  //save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _EditHabitNameController.text;
    });
    Navigator.pop(context);
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          backgroundColor: Colors.grey[200],
          floatingActionButton: MyFloatingActionButton2(
            onPressed: createNewHabit,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: ListView(
            children: [
              IconButton(
                alignment: Alignment.topLeft,
                icon: Icon(Icons.info_outline),
                iconSize: 25,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text(
                              "Break Habits",
                              style: TextStyle(fontSize: 24.0),
                            ),
                            content: Text(
                              "Press the \u{2795} button to add habits you want to break \n\n \u{2611} Check the habits at the end of the day \n\n \u{1F4C5} View monthly progress in a single view on the calendar \n\n\n Aim for the Golden streak!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              //monthly summary heat map
              MonthlySummary2(
                  datasets: db.heatMapDataSet,
                  startDate: _myBox.get("START_DATE")),

              //list of habits
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  //habit tiles
                  return HabitTile2(
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                },
              ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _controller,
          emissionFrequency: 0.1,
          blastDirection: -pi / 2,
          gravity: 0.25,
          createParticlePath: drawStar,
        )
      ],
    );
  }
}
