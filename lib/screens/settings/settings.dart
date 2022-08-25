import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:water_app/screens/reminder/reminder.dart';
import 'package:water_app/widgets/custom_snackbar.dart';

import '../../main.dart';

class SettingsApp extends StatefulWidget {
  const SettingsApp({Key? key}) : super(key: key);

  @override
  State<SettingsApp> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsApp> {
  final weight = TextEditingController();
  final waterGoal = TextEditingController();
  int selectedGender = 0;
  setSelectedGender(value) {
    setState(() {
      showSave = true;
      genderSelected = true;
      selectedGender = value;
    });
  }

  TimeOfDay wakeup = const TimeOfDay(hour: 10, minute: 30);
  TimeOfDay bedtime = const TimeOfDay(hour: 10, minute: 30);
  final TextEditingController _awake = TextEditingController();
  final TextEditingController _asleep = TextEditingController();
  bool selection = false;

  bool weightSelected = false;
  bool genderSelected = false;
  bool bedtimeSelected = false;
  bool wakeupSelected = false;
  bool waterGoalSelected = false;
  bool showSave = false;

  void update() async {
    setState(() {
      weight.text = obj.getWeight();
      _awake.text = obj.getWakeup();
      _asleep.text = obj.getBedtime();
      selectedGender = obj.getGender();
      waterGoal.text = obj.getWaterGoal();

      log("info:");
      log(weight.text);
      log(_awake.text);
      log(_asleep.text);
      log(waterGoal.text);
      log("$selectedGender");

      if (selectedGender == 1) {
        selection = true;
      } else {
        selection = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 200, 225, 235),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Weight ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 159, 206),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: weight,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      onTap: () {
                        weightSelected = true;
                        if (showSave == false) {
                          setState(() {
                            showSave = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixText: "Kg",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.red),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "GENDER",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 159, 206),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    RadioListTile(
                      selected: selection,
                      title: const Text(
                        "Male",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      value: 1,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          setSelectedGender(value);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 101, 159, 206),
                    ),
                    RadioListTile(
                      selected: !selection,
                      title: const Text(
                        "Female",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      value: 2,
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          setSelectedGender(value);
                        });
                      },
                      activeColor: const Color.fromARGB(255, 101, 159, 206),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Wake Time",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 159, 206),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onTap: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: wakeup,
                        );
                        if (newTime == null) {
                          return;
                        }
                        showSave = true;
                        log("THE VALUE OF SHOW SAVE IS");
                        log("$showSave");
                        setState(
                          () {
                            wakeup = newTime;

                            wakeupSelected = true;
                            _awake.text = newTime.format(context);
                            log("showSave=$showSave");
                          },
                        );
                      },
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      controller: _awake,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Bed Time",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 159, 206),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onTap: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: bedtime,
                        );
                        if (newTime == null) {
                          return;
                        }
                        setState(() {
                          showSave = true;
                          bedtimeSelected = true;
                          bedtime = newTime;

                          _asleep.text = newTime.format(context);
                        });
                      },
                      style: const TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      controller: _asleep,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.access_time),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Water Intake Goal",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 159, 206),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: waterGoal,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      onTap: () {
                        waterGoalSelected = true;
                        if (showSave == false) {
                          setState(() {
                            showSave = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        suffixText: "ml",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.red),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 101, 159, 206),
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Reminder Schedule ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Reminder()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Visibility(
                  visible: showSave,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 50),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 101, 159, 206),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 101, 159, 206),
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      wakeup = obj.fromString(_awake.text);
                      bedtime = obj.fromString(_asleep.text);
                      if (wakeup == bedtime) {
                        customSnackbar(
                          context,
                          "Bed time cannot be same as Wakeup time",
                        );
                      } else if (weight.text.isEmpty) {
                        customSnackbar(
                          context,
                          "Please enter a valid weight value",
                        );
                      } else if (double.parse(weight.text) < 20) {
                        customSnackbar(
                          context,
                          "Weight must be greater than or equal 20kg",
                        );
                      } else if (double.parse(weight.text) > 300) {
                        customSnackbar(
                            context, "Weight must be less than or equal 300kg");
                      } else if (double.parse(waterGoal.text) < 250 ||
                          double.parse(waterGoal.text) >= 6000) {
                        customSnackbar(
                          context,
                          "Water goal must be greater than atleast 250ml and less then 6000ml",
                        );
                      } else if (waterGoal.text.isEmpty == true) {
                        customSnackbar(
                          context,
                          "Water goal cannot be empty",
                        );
                      } else {
                        if (waterGoalSelected) {
                          obj.updateWaterGoalOnly(int.parse(waterGoal
                              .text)); //put checks here like epty or null
                        }

                        if (weightSelected) {
                          obj.updateWeight(int.parse((weight.text)));
                        }
                        if (genderSelected) {
                          obj.updateGender(selectedGender);
                        }
                        if (wakeupSelected) {
                          obj.updateWakeUp(_awake.text);
                        }
                        if (bedtimeSelected) {
                          obj.updateBedTime(_asleep.text);
                        }

                        update();
                        customSnackbar(
                          context,
                          "Changes Saved",
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
