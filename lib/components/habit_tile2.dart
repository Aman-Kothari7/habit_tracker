import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile2 extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile2(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged,
      required this.settingsTapped,
      required this.deleteTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          //setting option
          SlidableAction(
            onPressed: settingsTapped,
            backgroundColor: Colors.grey.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(12),
          ),

          //delete option
          SlidableAction(
            onPressed: deleteTapped,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          height: 75,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            //color: Colors.grey[100],
            color: habitCompleted == true ? Colors.red[300]: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              //checkbox
              Checkbox(
                  value: habitCompleted,
                  activeColor: Colors.red[300],
                  onChanged: onChanged),
              //habit title
              SizedBox(
                child: Text(
                  maxLines: 1,
                  habitName,
                  style: TextStyle(
                    color: habitCompleted == true ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),
              Icon(
                Icons.arrow_left,
                size: 33.0,
                color: habitCompleted == true ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
    // }
  }
}
