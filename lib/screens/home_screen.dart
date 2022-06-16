import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubenwa/models/newborns.dart';
import 'package:ubenwa/utils/app_colors.dart';
import 'package:workmanager/workmanager.dart';

import '../models/datum.dart';
import '../providers/dio_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  bool startStop = true;

  startTimer() {
    print("Timer is started");
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      print("MADE CREATENEWBORN REQUEST");
      // handleCreateNewbornRequest();
      setState(() {});
      //mytimer.cancel() //to terminate this timer
    });
  }

  stopTimer() {
    timer?.cancel();
    print("Timer is Cancel");
    setState(() {});
  }

  String time = "";
  // @override
  // void initState() {
  //   Timer timer = Timer.periodic(Duration(seconds: 10), (timer) {
  //     _handleCreateNewbornRequest();
  //     setState(() {});
  //     //mytimer.cancel() //to terminate this timer
  //   });
  //   // timer.isActive;
  //
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  static Future<void> handleCreateNewbornRequest(BuildContext context) async {
    await Provider.of<DioClient>(context, listen: false).createNewBorn(
        name: "Mr just",
        gestation: "2021-08-26T12:04:50.821Z",
        gender: "female");
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: TextButton(
    //       onPressed: _submit,
    //       child: Text("Create New born"),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Workmanager().registerOneOffTask(
                        "taskone",
                        "testTask",
                        initialDelay: Duration(seconds: 5),
                      );
                    },
                    child: Text("Start"),
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.kButtonColor,
                        onPrimary: Colors.white,
                        elevation: 0, // Elev
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)) // ation
                        ),
                  ),
                  ElevatedButton(
                    onPressed: stopTimer,
                    child: Text("Stop"),
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.kButtonColor,
                        onPrimary: Colors.white,
                        elevation: 0, // Elev
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)) // ation
                        ),
                  ),
                ],
              ),
              FutureBuilder<Newborns?>(
                // future: _dioClient.viewAllNewborns(),
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
                                          style: TextStyle(
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
