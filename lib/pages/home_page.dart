import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile.dart';
import '../components/monthly_summary.dart';
import '../components/my_fab.dart';
import '../components/my_alert_box.dart';
import 'home_page2.dart';

import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int currentIndex = 0;
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
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

  //checkbox was tapped
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
          controller: _newHabitNameController,
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
      db.todaysHabitList[index][0] = _newHabitNameController.text;
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
          backgroundColor: Colors.grey[300],
          floatingActionButton: MyFloatingActionButton(
            onPressed: createNewHabit,
          ),
          body: ListView(
            children: [
              //monthly summary heat map
              MonthlySummary(
                  datasets: db.heatMapDataSet,
                  startDate: _myBox.get("START_DATE")),

              //list of habits
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  //habit tiles
                  return HabitTile(
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
