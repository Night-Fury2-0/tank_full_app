import 'dart:io';
import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'globals.dart' as globals;
import 'package:native_notify/native_notify.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'settings_screen.dart';
import 'help_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(2008, 'Z2e68owQIdIjAXVM5tbQu0', null, null);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank-Full',
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
      home: const MyHomePage(title: 'Tank-Full'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Path _buildBoatPath() {
  return Path()
    ..moveTo(15, 120)
    ..lineTo(0, 85)
    ..lineTo(50, 85)
    ..lineTo(50, 0)
    ..lineTo(105, 80)
    ..lineTo(60, 80)
    ..lineTo(60, 85)
    ..lineTo(120, 85)
    ..lineTo(105, 120)
    ..close();
}

class _MyHomePageState extends State<MyHomePage> {
  final water_level = 202;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                child: Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
                child: Icon(Icons.help),
              )),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                threshold();
              },
              child: Text('Check'),
            ),
            //Tank widget and graph widgets go inside this "children" container(?)

            //Tank code goes here********************************************************************************
            LiquidCustomProgressIndicator(
              value: 0.3, // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(
                  Colors.blue), // Defaults to the current Theme's accentColor.
              backgroundColor: Colors
                  .white, // Defaults to the current Theme's backgroundColor.
              direction: Axis
                  .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
              shapePath:
                  _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
            ),
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //*******************************************************************************************************************************************

            //Graph code goes here**********************************************************************************************************************
            Text("Graph 1 goes here"),
            Text("Graph 2 goes here"),
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //*
          ],
        ),
      ),
    );
  }

  void threshold() {
    int checker = 1;

    if (water_level < 50 && checker == 1) {
      if(globals.NotificationState){
        pushNoteApi('Low threshold', 'Your water tank is Low');
        checker = 0;
      }
      
    } else if (water_level > 200) {
      if(globals.NotificationState){
        pushNoteApi('Upper threshold', 'Your water tank is almost full');
        checker = 1;
      }

    } else {
      checker = 1;
    }
  }
}

void pushNoteApi(String title, String message) {
  final uri =
      Uri.parse('https://app.nativenotify.com/api/flutter/notification');

  http.post(uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({
        HttpHeaders.contentTypeHeader: 'application/json',
        'flutterAppId': '2008',
        'flutterAppToken': 'Z2e68owQIdIjAXVM5tbQu0',
        'title': title,
        'body': message,
      }));
}
