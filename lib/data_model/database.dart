import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:water_app/components/water_intake.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
    .collection('users')
    .doc("1")
    .collection("WaterRecord")
    .snapshots();

class DataModal {
  int weight = 0;
  int gender = 0;
  String wakeUp = "";
  String bedTime = "";
  int waterGoal = 0;
  int waterDrunk = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  double limit = 0;
  int reminderCount = 0;
  int reminderGap = 0;

  DataModal();

  void setWeight(int userWeight) {
    weight = userWeight;
  }

  void setGender(int userGender) {
    gender = userGender;
  }

  void setRoutine(String userWakeup, String userBedtime) {
    wakeUp = userWakeup;
    bedTime = userBedtime;
  }

  void setWaterGoal() {
    waterGoal = calculatetIntake(weight);
  }

  void initaliseFireBase() {
    waterGoal = calculatetIntake(weight);

    users.doc('1').set(
      {
        'weight': weight,
        'gender': gender, // where 1 specifies male and 2 specifies female
        'wakeup': wakeUp,
        'bedtime': bedTime,
        'waterGoal': waterGoal,
        'waterDrunk': 0,
      },
    );
  }

  void getCurrentFirebase() async {
    await FirebaseFirestore.instance.collection('users').doc('1').get().then(
      (DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;
        weight = data['weight'];
        wakeUp = data['wakeup'];
        bedTime = data['bedtime'];
        gender = data['gender'];
        waterGoal = data['waterGoal'];
        waterDrunk = data['waterDrunk'];
      },
    );
  }

  String getWeight() {
    return weight.toString();
  }

  String getWakeup() {
    return wakeUp;
  }

  String getBedtime() {
    return bedTime;
  }

  int getGender() {
    return gender;
  }

  String getWaterGoal() {
    return waterGoal.toString();
  }

  int getWaterGoalInt() {
    return waterGoal;
  }

  int getWaterDrunk() {
    return waterDrunk;
  }

  Future<void> updateWeight(userWeight) async {
    users.doc('1').update({'weight': userWeight});
    updateWaterGoal(userWeight);
    weight = userWeight;
  }

  Future<void> updateWaterGoal(weight) async {
    users.doc('1').update(
      {
        'waterGoal': calculatetIntake(weight),
      },
    );

    waterGoal = calculatetIntake(weight);
    limit = waterGoal / 250;
  }

  Future<void> updateWaterGoalOnly(int goal) async {
    users.doc('1').update(
      {
        'waterGoal': goal,
      },
    );

    waterGoal = goal;
    limit = waterGoal / 250;
  }

  Future<void> updateWaterDrunk(water) async {
    users.doc('1').update(
      {
        'waterDrunk': water,
      },
    );
    waterDrunk = water;
  }

  Future<void> updateGender(int userGender) async {
    users.doc('1').update({'gender': userGender});
    gender = userGender;
  }

  Future<void> updateWakeUp(String time) async {
    users.doc('1').update({'wakeup': time});
    wakeUp = time;
  }

  Future<void> updateBedTime(String time) async {
    users.doc('1').update({'bedtime': time});
    bedTime = time;
  }

  final String uid = '1';
  int rid = 0;

  //make a collection refernce to our database
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final Stream<QuerySnapshot> usersStreamRecord = FirebaseFirestore.instance
      .collection('users')
      .doc("1")
      .collection("WaterRecord")
      .snapshots();

  Future updateWaterRecord(String time) async {
    await userCollection
        .doc(uid)
        .collection('WaterRecord')
        .doc()
        .set({"record": time});
  }

  Future updateSpecificWaterRecord(String recordID, String time) async {
    await userCollection
        .doc(uid)
        .collection('WaterRecord')
        .doc(recordID)
        .update({"record": time});
  }

  TimeOfDay fromString(String time) {
    int hh = 0;
    if (time.endsWith('PM')) hh = 12;
    time = time.split(' ')[0];
    return TimeOfDay(
      hour: hh +
          int.parse(time.split(":")[0]) %
              24, // in case of a bad time format entered manually by the user
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }

  void inialiseRid(int length) {
    rid = length;
  }

  Future deleteRecord(String id) async {
    await userCollection.doc(uid).collection('WaterRecord').doc(id).delete();
  }

  final Stream<QuerySnapshot> usersStreamReminder = FirebaseFirestore.instance
      .collection('users')
      .doc("1")
      .collection("Reminder")
      .orderBy('time', descending: true)
      .snapshots();

  Future createReminder(String time) async {
    await userCollection.doc(uid).collection('Reminder').doc().set({
      "time": time,
      "status": 1, //one status means that a reminder is in ON state
    });
  }

  Future updateSpecificReminder(String id, String time) async {
    await userCollection.doc(uid).collection('Reminder').doc(id).update({
      "time": time,
    });
  }

  Future deleteReminder(String id) async {
    await userCollection.doc(uid).collection('Reminder').doc(id).delete();
  }

  Future toggleReminder(int status, String id) async {
    await userCollection.doc(uid).collection('Reminder').doc(id).update({
      "status": status, //one status means that a reminder is in ON state
    });
  }

  void inialiseCurrentReminderCount(int length) {
    reminderCount = length;
  }

  void buildSchedule() {
    double limit = waterGoal / 250;

    for (int i = 0; i < limit; i++) {}
  }

  void initaliseReminderAuto(context) async {
    double limit = waterGoal / 250;
    limit = limit.roundToDouble();

    for (int i = 0; i < limit; i++) {
      log("akeup=$wakeUp");
      log("$limit");

      log("$i");
      TimeOfDay t = fromString(wakeUp);

      DateTime now = DateTime.now();

      DateTime newtime = DateTime(
          now.year, now.month, now.day, t.hour, t.minute + 1 + reminderGap * i);

      String input = TimeOfDay.fromDateTime(newtime).format(context);

      createReminder(input);
    }
  }

  bool checktime(TimeOfDay wakeup, TimeOfDay bedtime) {
    double hoursAwake = 0;
    double reminderInterval = 0;
    if (wakeup.hour < bedtime.hour) {
      int totalAwakeTime = (bedtime.hour * 60 + bedtime.minute) -
          (wakeup.hour * 60 + wakeup.minute);
      reminderInterval = (totalAwakeTime / (waterGoal / 250));
      hoursAwake = totalAwakeTime / 60;
    } else {
      int totalAwakeTime = (24 - (wakeup.hour)) * 60 +
          (60 - wakeup.minute) +
          (bedtime.hour * 60 + bedtime.minute);

      hoursAwake = totalAwakeTime / 60;
      reminderInterval = (totalAwakeTime / (waterGoal / 250));
    }
    reminderGap = reminderInterval.round();

    if (hoursAwake < 20 && hoursAwake > 12) {
      return true;
    } else {
      return false;
    }
  }

  //now to create auto reminders
}
