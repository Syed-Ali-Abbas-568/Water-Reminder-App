import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_app/components/alert.dart';
import 'package:water_app/widgets/custom_snackbar.dart';

import '../../main.dart';
import '../../widgets/custom_picker.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  void delete(id) async {
    await obj.deleteReminder(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reminders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 200, 225, 235),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: obj.usersStreamReminder,
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  obj.inialiseRid(streamSnapshot.data!.docs.length);

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      obj.inialiseCurrentReminderCount(
                          streamSnapshot.data!.docs.length);
                      String id = documentSnapshot.id;
                      bool isSwitched = false;
                      if (documentSnapshot['status'] == 1) {
                        isSwitched = true;
                      } else {
                        isSwitched = false;
                      }

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "💧 ${documentSnapshot['time']}",
                            style: const TextStyle(fontSize: 30),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          title: Switch(
                            value: isSwitched,
                            onChanged: (value) async {
                              isSwitched = !isSwitched;
                              if (isSwitched == false) {
                                await obj.toggleReminder(0, id);
                              } else {
                                await obj.toggleReminder(1, id);
                              }
                            },
                            activeTrackColor:
                                const Color.fromARGB(255, 87, 181, 202),
                            activeColor:
                                const Color.fromARGB(255, 40, 115, 173),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      String newTime = await customTimePicker(
                                          context,
                                          obj.fromString(
                                              documentSnapshot['time']));
                                      obj.updateSpecificReminder(id, newTime);
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    void dosomething() {}

                                    alertBox(context, id, 1, dosomething);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (streamSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No Reminders Found",
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (obj.reminderCount <= (obj.waterGoal / 250)) {
            String newTime = await customTimePicker(context, TimeOfDay.now());
            obj.createReminder(newTime);
          } else {
            customSnackbar(context,
                "Reminder Limit for current water goal reached. Increase watergoal to add more");
          }
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
