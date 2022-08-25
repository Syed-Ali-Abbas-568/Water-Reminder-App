import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:water_app/screens/on_boarding_screens/sleep_cycle.dart';
import '../../main.dart';

class Gender extends StatefulWidget {
  const Gender({Key? key}) : super(key: key);
  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  int selectedGender = 0;

  setSelectedGender(value) {
    setState(() {
      selectedGender = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setSelectedGender(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                const Center(
                  child: Text(
                    "GENDER",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 101, 159, 206),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 140.0,
                ),
                RadioListTile(
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
                    setSelectedGender(value);
                  },
                  activeColor: const Color.fromARGB(255, 101, 159, 206),
                ),
                RadioListTile(
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
                    setSelectedGender(value);
                  },
                  activeColor: const Color.fromARGB(255, 101, 159, 206),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(20)),
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
                      "Continue",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (selectedGender == 0) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.lightBlueAccent,
                            content: Text(
                              'Please select gender',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        log("error1");
                        obj.setGender(selectedGender);
                        log("error2");

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SleepCycle()));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
