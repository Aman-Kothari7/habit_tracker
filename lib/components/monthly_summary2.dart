import 'package:flutter/material.dart';
//import 'package:flutter_heat_map/flutter_heat_map.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/datetime/date_time.dart';

class MonthlySummary2 extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary2(
      {super.key, required this.datasets, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      height: 310,
      width: 350,
      padding: const EdgeInsets.all(20),
      child: HeatMapCalendar(
        //startDate: createDateTimeObject(startDate),
        //endDate: DateTime.now().add(const Duration(days: 121)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[75],
        textColor: Colors.black,
        showColorTip: false,
        flexible: true,
        //showText: true,
        //scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(20, 222, 2, 2),
          2: Color.fromARGB(40, 222, 2, 2),
          3: Color.fromARGB(60, 222, 2, 2),
          4: Color.fromARGB(80, 222, 2, 2),
          5: Color.fromARGB(100, 222, 2, 2),
          6: Color.fromARGB(120, 222, 2, 2),
          7: Color.fromARGB(140, 222, 2, 2),
          8: Color.fromARGB(160, 222, 2, 2),
          9: Color.fromARGB(180, 222, 2, 2),
          10: Color.fromARGB(255, 243, 212, 108),
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
