import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function()? onPressed;

  const MyFloatingActionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      // mini: true,
      elevation: 20,
      child: Icon(Icons.add),
    );
  }
}
