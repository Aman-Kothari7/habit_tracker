import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //open a box
  await Hive.openBox("Habit_Database");
  await Hive.openBox("Habit_Database2");

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
