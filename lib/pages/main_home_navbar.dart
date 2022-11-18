import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive/hive.dart';

import '../components/habit_tile.dart';
import '../components/monthly_summary.dart';
import '../components/my_fab.dart';
import '../components/my_alert_box.dart';
import 'home_page.dart';
import 'home_page2.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int currentIndex = 0;

  final screens = [
    HomePage(),
    HomePage2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        selectedItemColor: Colors.amber,
        iconSize: 25,
        //selectedFontSize: 18,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            label: 'Make',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.broken_image_outlined),
            label: 'Break',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
