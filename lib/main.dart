import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubenwa/providers/dio_client.dart';
import 'package:ubenwa/screens/home_screen.dart';
import 'package:ubenwa/screens/login_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/signup_screen.dart';

Completer uploadCompleter = Completer();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case "uploadCompleter":
        log("This method was called from background");
        var r = handleCreateNewbornRequest();
        final sendPort = IsolateNameServer.lookupPortByName("notifyChannel");
        if (sendPort != null) {
          log("Background message sent.");
          sendPort.send(r);
        }
        break;
      case Workmanager.iOSBackgroundTask:
        log("Ios background fetch delegate ran");
        break;
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
          value: DioClient.instance,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
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
