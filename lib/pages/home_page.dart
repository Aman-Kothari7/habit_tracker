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
    // ignore: todo
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
    _EditHabitNameController.clear();
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
      alignment: Alignment.topCenter, //Confetti position
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[400],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "MAKE",
                  style: TextStyle(
                      color: Colors.white, fontSize: 22, letterSpacing: 2),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                alignment: Alignment.center,
                icon: const Icon(Icons.info_outline),
                iconSize: 25,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text(
                              "Make Habits",
                              style: TextStyle(fontSize: 24.0),
                            ),
                            content: Text(
                              "Press the \u{2795} button to add habits you want to form \n\n \u{2611} Check the habits at the end of the day \n\n \u{1F4C5} View monthly progress in a single view on the calendar \n\n\n Aim for the Golden streak!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ));
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[200],
          floatingActionButton: MyFloatingActionButton(
            onPressed: createNewHabit,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 20, 10),
                  child: TextButton.icon(
                      label: const Text(
                        "Make",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      icon: const Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.green,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 30, 10),
                  child: TextButton.icon(
                      label: const Text(
                        "Break",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage2()));
                      }),
                ),
              ],
            ),
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
          //createParticlePath: drawStar,
        )
      ],
    );
  }
}
