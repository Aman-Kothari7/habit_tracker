import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox(
      {super.key,
      this.controller,
      required this.hintText,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      backgroundColor: Colors.white,
      content: TextField(
        autofocus: true,
        maxLength: 30,
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          //enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.all(10),
      actions: [
        MaterialButton(
          onPressed: onSave,
          child: Text("Save", style: TextStyle(color: Colors.black)),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          elevation: 7,
        ),
        MaterialButton(
          onPressed: onCancel,
          child: Text("Cancel", style: TextStyle(color: Colors.black)),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          elevation: 7,
        ),
      ],
    );
  }
}
