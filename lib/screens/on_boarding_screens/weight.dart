import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:water_app/screens/on_boarding_screens/gender.dart';
import '../../main.dart';
import '../../widgets/custom_snackbar.dart';

class Weight extends StatelessWidget {
  const Weight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weight = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                const Center(
                  child: Text(
                    "WEIGHT",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 101, 159, 206),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  "Weight",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: weight,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixText: "Kg",
                    hintText: "Enter your weight",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
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
                      if (weight.text.isEmpty) {
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
                      } else {
                        obj.setWeight(int.parse(weight.text));
                        obj.setWaterGoal();

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Gender()));
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
