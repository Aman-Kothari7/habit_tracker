# habit_tracker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Additions:
Research:
https://strivecloud.io/blog/app-gamification/10-ways-to-drive-engagement/

Pending:
- Notifications - 1. everyday morning reminder to complete habits, 2. Evening - update on habits left/completed message
- Reward/celebration animation once habit is completed
- Reward/celebration complete all habits of the day
- Reward/celebration completed streak for 7 days - tokens : 7day streak progress bar
- Change color theme of app or Green Red

- Dos/ Dont's habits - heatmap for donts - slide between 2 pages

- Complete design overhaul


Completed:
- Box color to green after completed habit (if in color statement)
- Change setting icon to edit/rename icon

Future:
- Monthly statistics email
- Reminder option inapp
- Google ads integration
- Watch 20 sec ad if habits not completed by goal

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

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



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