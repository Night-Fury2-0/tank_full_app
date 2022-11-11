import 'dart:io';
import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'line_chart.dart';
import 'globals.dart' as globals;
import 'package:native_notify/native_notify.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:instabug_flutter/instabug_flutter.dart'; //For bug reporting

import 'settings_screen.dart';
import 'help_screen.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:intl/intl.dart';
import 'graph_data.dart';

import 'package:push/push.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(2008, 'Z2e68owQIdIjAXVM5tbQu0', null, null);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

          brightness: themeMode()),
      home: MyHomePage(title: 'Tank-Full'),
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
    ..lineTo(0, 185)
    ..cubicTo(0, 185, 0, 200, 15, 200)
    ..lineTo(135, 200)
    ..cubicTo(135, 200, 150, 200, 150, 185)
    ..lineTo(150, 60)
    ..lineTo(105, 15)
    ..lineTo(105, 7)
    ..cubicTo(105, 7, 105, 3, 100, 3)
    ..lineTo(50, 3)
    ..cubicTo(50, 3, 46, 3, 45, 7)
    ..lineTo(45, 15)
    ..lineTo(0, 60)
    ..close();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //Controller for the Lottie ( Used for tank animation )

  @override
  void initState() {
    Instabug.start('144c393c30a9ca42526659d95264c2d6', [InvocationEvent.none]);
  }

  String inflowFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
  String outflowFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
  String tankFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
  List<GraphData> inFlow = <GraphData>[];
  List<GraphData> outFlow = <GraphData>[];

  getData() async {
    inflowFromfile = await rootBundle.loadString('assets/InFlowData.txt');
    outflowFromfile = await rootBundle.loadString('assets/OutFlowData.txt');
    tankFromfile = await rootBundle.loadString('assets/TankLevelData.txt');

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  final water_level = 202;

  @override
  Widget build(BuildContext context) {
    var level = 0.65;

    final percentage = level * 100;
    var color;
    if (level <= 0.25) {
      color = AlwaysStoppedAnimation(Colors.red);
    } else {
      color = AlwaysStoppedAnimation(Colors.blue);
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    getData();
    getList();

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Logo_appbar_negative.png',
              fit: BoxFit.cover,
              //height: 32,
              //width: 32,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(1, 1, 0, 1),
                child: Text(widget.title))
          ],
        ),
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
        child: SingleChildScrollView(
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
              value: level, // Defaults to 0.5.
              valueColor: color, // Defaults to the current Theme's accentColor.
              backgroundColor: Color.fromARGB(255, 130, 123,
                  123), // Defaults to the current Theme's backgroundColor.
              direction: Axis
                  .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
              shapePath:
                  _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
              //var percentage,

              center: Text(
                "${percentage.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Color.fromARGB(255, 48, 40, 40),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            Card(
                color: themeColor(),
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.grey.withOpacity(0.4),
                      onTap: () {
                        onTapExpand(context,
                            Graph(graphTitle: 'In-flow', data: inFlow));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 20,
                                width: 20,
                                color: Colors.transparent,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Icon(Icons.open_in_full, size: 20),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                        height: 180,
                        width: 400,
                        child: Graph(
                          graphTitle: 'In-flow',
                          data: inFlow,
                        )),
                  ],
                )),
            Card(
                color: themeColor(),
                child: Column(
                  children: [
                    InkWell(
                      splashColor: Colors.grey.withOpacity(0.4),
                      onTap: () {
                        onTapExpand(context,
                            Graph(graphTitle: 'Out-flow', data: outFlow));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: 20,
                                width: 20,
                                color: Colors.transparent,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                  child: Icon(Icons.open_in_full, size: 20),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                        height: 180,
                        width: 400,
                        child: Graph(
                          graphTitle: 'Out flow',
                          data: outFlow,
                        )),
                  ],
                )),
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
            //*)
          ],
        )),
      ),
    );
  }

  void getList() {
    Map<String, double> graphLable1 = {};
    Map<String, double> graphLable2 = {};

    List<double> Indata = [];
    List<double> Outdata = [];
    List<double> Tankdata = [];
    List<String> splittedIn = inflowFromfile.split(" ");
    List<String> splittedOut = outflowFromfile.split(" ");
    List<String> splittedTank = tankFromfile.split(" ");
    List<GraphData> inf = <GraphData>[];
    List<GraphData> outf = <GraphData>[];

    for (int i = 0; i < 30; i++) {
      Indata.add(double.parse(splittedIn[i]));
      Outdata.add(double.parse(splittedOut[i]));
      //Tankdata.add(double.parse(splittedTank[i]));
    }

    //Populates the map with dates of past 30 days from today, and random values as "liters"
    for (int i = 29; i >= 0; i--) {
      //Gets current day
      var now = DateTime.now();
      //Formats the data to Month-Day
      var formatter = DateFormat('dd-MM');
      //Gets past 30 days using 'i'
      var date = DateTime(now.year, now.month, now.day - i);

      //Creates string of the date and formats it
      String formattedDate = formatter.format(date);
      //Adding pairs to the map (using a random generator for liter values)
      graphLable1[formattedDate] = Indata[i];
      graphLable2[formattedDate] = Outdata[i];
    }

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable1.entries) {
      inf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable2.entries) {
      outf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    //setState(() {
    inFlow = inf;
    outFlow = outf;
    //});

    //return dataTest;
  }

  void threshold() {
    int checker = 1;

    if (water_level < 50 && checker == 1) {
      if (globals.NotificationState) {
        pushNoteApi('Low threshold', 'Your water tank is Low');
        checker = 0;
      }
    } else if (water_level > 200) {
      if (globals.NotificationState) {
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

Brightness themeMode() {
  if (globals.ThemeMode) {
    return Brightness.dark;
  } else {
    return Brightness.light;
  }
}

Color themeColor() {
  if (globals.ThemeMode) {
    return Color.fromARGB(255, 48, 49, 48);
  } else {
    return Color.fromARGB(255, 250, 250, 249);
  }
}
