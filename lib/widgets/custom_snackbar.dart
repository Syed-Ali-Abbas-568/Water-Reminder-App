import 'package:flutter/material.dart';

void customSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      content: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    ),
  );
}
