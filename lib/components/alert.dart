import 'package:flutter/material.dart';

import '../main.dart';

Future alertBox(ctx, id, int mode, Function func) async {
  showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
            title: const Text('Alert'),
            content: const Text('Are you sure you want to delete this?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx, false);
                  if (mode == 1) {
                    await obj.deleteReminder(id);
                  } else {
                    await obj.deleteRecord(id);

                    func.call();
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ));
}
