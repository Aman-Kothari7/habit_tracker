import 'package:flutter/material.dart';

class MyFloatingActionButton2 extends StatelessWidget {
  final Function()? onPressed;

  const MyFloatingActionButton2({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: onPressed,
      child: Icon(Icons.add),
    );
  }
}
