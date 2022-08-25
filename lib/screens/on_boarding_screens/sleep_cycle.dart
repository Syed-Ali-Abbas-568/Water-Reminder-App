import 'package:flutter/material.dart';

import 'package:water_app/components/navbar.dart';
import 'package:water_app/widgets/custom_snackbar.dart';
import '../../main.dart';

class SleepCycle extends StatefulWidget {
  const SleepCycle({Key? key}) : super(key: key);
  @override
  State<SleepCycle> createState() => _SleepCycleState();
}

class _SleepCycleState extends State<SleepCycle> {
  TimeOfDay wakeup = const TimeOfDay(hour: 10, minute: 30);
  TimeOfDay bedtime = const TimeOfDay(hour: 10, minute: 30);

  final TextEditingController _awake = TextEditingController();
  final TextEditingController _asleep = TextEditingController();

  @override
  void initState() {
    super.initState();
    _awake.text = "10 : 30 AM";
    _asleep.text = "10 : 30 AM";
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
                    "SLEEP CYCLE",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Wake Time",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.left,
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
                        setState(() {
                          wakeup = newTime;

                          _awake.text = wakeup.format(context);
                        });
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
                      ),
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
                          bedtime = newTime;

                          _asleep.text = bedtime.format(context);
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
                  ],
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
                      if (wakeup == bedtime) {
                        customSnackbar(
                            context, 'Bedtime cannot be same as wakeup time');
                      } else if (obj.checktime(wakeup, bedtime) == false) {
                        customSnackbar(context,
                            "Awake Time for user must be greater than 12 hours or less than 20 hours");
                      } else {
                        obj.setRoutine(_awake.text, _asleep.text);
                        obj.initaliseFireBase();

                        obj.initaliseReminderAuto(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const NavBar()));
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
