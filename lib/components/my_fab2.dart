import 'package:flutter/material.dart';

class MyFloatingActionButton2 extends StatelessWidget {
  final Function()? onPressed;

  const MyFloatingActionButton2({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: onPressed,
      //elevation: 20,
      child: Icon(Icons.add),
    );
  }
}
