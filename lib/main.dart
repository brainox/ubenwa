import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubenwa/providers/newborns_service.dart';
import 'package:ubenwa/providers/dio_client.dart';
import 'package:ubenwa/screens/home_screen.dart';
import 'package:ubenwa/screens/login_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/signup_screen.dart';

const androidTask = "androidBackgroundTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case androidTask:
        print("Android called background task: $task");
        HomeScreen;
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS called background task: $task");
        break;
    }
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DioClient(),
        ),
        ChangeNotifierProvider.value(
          value: NewbornsService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const SignUpScreen(),
        routes: {
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
