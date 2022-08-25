import 'package:flutter/material.dart';

Future<String> customTimePicker(
    BuildContext context, TimeOfDay initialTimeGiven) async {
  TimeOfDay? newtime =
      await showTimePicker(context: context, initialTime: initialTimeGiven);

  if (newtime == null) {
    return initialTimeGiven.format(context);
  } else {
    return newtime.format(context);
  }
}
