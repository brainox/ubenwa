import 'dart:async';
import 'dart:developer' as log;
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ubenwa/models/newborns.dart';
import 'package:ubenwa/utils/app_colors.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';
import '../models/datum.dart';
import '../providers/dio_client.dart';
import '../utils/result.dart';

Future<Result<void>> handleCreateNewbornRequest() async {
  var newbornsName = [
    "Kingsley",
    "Esther",
    "Victor",
    "Prince",
    "Michael",
    "Amina",
    "Buhari",
    "Stella",
    "Rachael",
    "Gospel"
  ];
  var newbornsGender = [
    "male",
    "female",
    "male",
    'male',
    "male",
    "female",
    "male",
    "female",
    "female",
    "male"
  ];

  Random random = Random();
  int randomIndex = random.nextInt(11);

  var result = await DioClient.instance.createNewBorn(
      name: newbornsName[randomIndex],
      gestation: "2021-08-26T12:04:50.821Z",
      gender: newbornsGender[randomIndex]);

  return result;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool value = false;

  String time = "";
  @override
  void initState() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log.log("message before port opened");
    var port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, "notifyChannel");
    log.log("port have been registered to a port");
    port.listen((dynamic data) async {
      log.log("got data from $data from isolate");
    });
  }

  onchange(bool value) {
    setState(() {
      this.value = value;

      if (this.value == true) {
        Workmanager().registerPeriodicTask(
          "1",
          "uploadCompleter",
          frequency: const Duration(minutes: 20),
        );
        handleCreateNewbornRequest();
      } else {
        Workmanager().cancelAll();
      }
    });
  }

  Widget buildSwitch() => Transform.scale(
        scale: 2,
        child: Switch.adaptive(
            value: value, onChanged: (value) => onchange(value)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home View"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              buildSwitch(),
              FutureBuilder<Newborns?>(
                future: Provider.of<DioClient>(context, listen: false)
                    .viewAllNewborns(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    Newborns? newbornsList = snapShot.data;
                    if (newbornsList != null) {
                      List<Datum> newBornData = newbornsList.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: newBornData
                            .map((e) => Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(),
                                  child: Container(
                                    height: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          time,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink),
                                        ),
                                        Text(e.attributes.name),
                                        Text(e.attributes.gender),
                                        Text(e.attributes.gestation
                                            .toLocal()
                                            .toString())
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                      // return Text('${newBornData}');
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
