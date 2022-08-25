import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

import 'package:water_app/components/water_intake.dart';
//import 'package:water_app/notification/notification_service.dart';
import 'package:water_app/widgets/custom_picker.dart';

import '../../components/alert.dart';
import '../../main.dart';
import 'package:water_app/widgets/custom_snackbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int water = 0;
  int drunk = 0;
  double percent = 0;

  void update() async {
    setState(() {
      water = obj.getWaterGoalInt();
      drunk = obj.getWaterDrunk();

      percent = double.parse(calculatePercent(drunk, water).toStringAsFixed(2));
    });
  }

  void drinkglass() async {
    setState(() {
      drunk = drunk + 250;
      obj.updateWaterDrunk(drunk);
      percent = double.parse(calculatePercent(drunk, water).toStringAsFixed(2));
    });
  }

  void removeglass() async {
    setState(() {
      drunk = drunk - 250;
      obj.updateWaterDrunk(drunk);
      percent = double.parse(calculatePercent(drunk, water).toStringAsFixed(2));
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
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 200, 225, 235),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/tip.png',
                  scale: 12,
                ),
                ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  margin: const EdgeInsets.only(top: 20),
                  backGroundColor: Colors.blue,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: const Text(
                      "Do not drink cold water immediately \n after hot drinks",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 200,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: LinearProgressIndicator(
                          value: (percent / 100),
                          valueColor: const AlwaysStoppedAnimation(
                            Color.fromARGB(255, 73, 128, 215),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 132, 190, 241),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 32.0,
                              color: Colors.blue,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: '$drunk'),
                              TextSpan(
                                text: '/ $water ml \n',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "You have completed\n $percent % of Daily Target\n",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        TextButton(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 101, 159, 206),
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "Add Water",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Icon(Icons.local_drink),
                            ],
                          ),
                          onPressed: () {
                            if ((drunk) < water) {
                              drinkglass();
                              String currentTime =
                                  TimeOfDay.now().format(context);
                              obj.updateWaterRecord(currentTime);
                            } else {
                              customSnackbar(
                                context,
                                "Water Goal has been reached or will be exceeded please increase watergoal",
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              "Today Record",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
              textAlign: TextAlign.left,
            ),
            StreamBuilder(
              stream: obj.usersStreamRecord,
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

                      String id = documentSnapshot.id;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: const Text("Added 250ml 💧"),
                          subtitle: Text(documentSnapshot['record']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<int>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: const [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Edit Time")
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: const [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Delete")
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) async {
                                    if (value == 1) {
                                      String newTime = await customTimePicker(
                                          context,
                                          obj.fromString(
                                              documentSnapshot['record']));

                                      await obj.updateSpecificWaterRecord(
                                          id, newTime);
                                    } else if (value == 2) {
                                      alertBox(context, id, 2, removeglass);
                                    }
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
                  return const CircularProgressIndicator(
                    strokeWidth: 5.0,
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
