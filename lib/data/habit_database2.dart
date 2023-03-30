import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box("Habit_Database2");

class HabitDatabase2 {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create initial default data
  void createDefaultData() {
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //load data if it already exists
  void loadData() {
    //if new day, get habit list

    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");

      //set all habit completed to false since its a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }

    //if its not a new day, load todays list
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //update database
  void updateDatabase() {
    //update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    //update universal habit list in case it changes(new,edit,delete)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    //calculate habit complete percentages for each day
    calculateHabitPercentages();

    //loadHeatMap
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd
    // value: string of 1dp number between 0-1 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    //count number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //from start date to today and add each percentage
    // "PERCENTAGE_SUMMARY_$yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strength = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      //split the datetime up like below so it doesnt worry about hours/min/sec etc
      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }

  bool checkCompleteHabits() {
    bool todayHabitsCompleted = false;
    int countComplete = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countComplete++;
      }
    }

    if (todaysHabitList.length == countComplete) {
      todayHabitsCompleted = true;
    }

    return todayHabitsCompleted;
  }
}
