import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:flutter/services.dart' show SystemChrome, rootBundle;
import 'dart:async';
import 'package:intl/intl.dart';
import 'graph_data.dart';
import 'package:screenshot/screenshot.dart';
import 'package:push/push.dart';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';
//import 'package:stream_transform/stream_transform.dart';

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
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  String inflowFromfile =
      "905 1055 1190 1307 1399 1463 1495 1495 1463 1399 1307 1190 1055 905 749 594 444 309 192 100 36 4 4 36 100 192 309 444 594 750";
  String outflowFromfile =
      "362 422 476 522 559 585 598 598 585 559 522 476 422 362 299 237 177 123 77 40 14 1 1 14 40 77 123 177 237 300";
  String tankFromfile =
      "541 741 525 1063 742 802 762 1426 824 1130 597 605 648 503 387 140 238 363 65 273 361 218 343 203 342 402 228 320 119 767";
  //List<GraphData> inFlow = <GraphData>[];
  //List<GraphData> outFlow = <GraphData>[];
  List<double> Indata = [];
  List<double> Outdata = [];

  //var water_level = 0.0;
  bool checkerL = true;
  bool checkerU = true;

  getData() async {
    inflowFromfile = await rootBundle.loadString('assets/InFlowData.txt');
    outflowFromfile = await rootBundle.loadString('assets/OutFlowData.txt');
    tankFromfile = await rootBundle.loadString('assets/TankLevelData.txt');
  }

  Stream<GraphData> inputData() async* {
    for (int i = 0; i < 30; i++) {
      var now = DateTime.now();
      //Formats the data to Month-Day
      var formatter = DateFormat('dd-MM');
      //Gets past 30 days using 'i'
      var date = DateTime(now.year, now.month, now.day + i + 1);

      //Creates string of the date and formats it
      String formattedDate = formatter.format(date);

      await Future<void>.delayed(const Duration(seconds: 1));
      globals.inFlow.removeAt(0);
      print('In: ${globals.inFlow[i].liter}');
      yield GraphData(formattedDate, Indata[i]);
    }
  }

  Stream<GraphData> outputData() async* {
    for (int i = 0; i < 30; i++) {
      var now = DateTime.now();
      //Formats the data to Month-Day
      var formatter = DateFormat('dd-MM');
      //Gets past 30 days using 'i'
      var date = DateTime(now.year, now.month, now.day + i + 1);

      //Creates string of the date and formats it
      String formattedDate = formatter.format(date);

      await Future<void>.delayed(const Duration(seconds: 1));
      globals.outFlow.removeAt(0);
      print("Tank: ${globals.outFlow[i].liter}");
      yield GraphData(formattedDate, Outdata[i]);
    }
  }

  Stream<dynamic> gettankData() async* {
    for (int i = 0; i < 30; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      print("Out: ${globals.Tankdata[i]}");
      threshold(globals.Tankdata[i]);
      yield (globals.Tankdata[i] / 1500);
    }
  }

  //Initilizes the instabug package
  @override
  void initState() {
    Instabug.start('144c393c30a9ca42526659d95264c2d6', [InvocationEvent.none]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<GraphData> stream1 = inputData().asBroadcastStream();
    Stream<GraphData> stream2 = outputData().asBroadcastStream();
    Stream<dynamic> stream3 = gettankData().asBroadcastStream();

    var level = 0.65;

    var percentage = level * 100;
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
    //Future.delayed(const Duration(seconds: 150), () {
    //etData();
    //});

    getList();

    return Scaffold(
      drawer: NavBar(),
      onDrawerChanged: (isOpened) async {},
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/Logo_appbar_negative.png',
              fit: BoxFit.cover,
              height: 32,
              width: 32,
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
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //
            //
            //
            //Tank widget and graph widgets go inside this "children" container(?)

            //Tank code goes here********************************************************************************

            StreamBuilder(
                stream: stream3,
                builder: (context, AsyncSnapshot<dynamic> snapshot1) {
                  if (snapshot1.hasData) {
                    level = snapshot1.data!;
                    percentage = level * 100;
                    if (level <= 0.25) {
                      color = AlwaysStoppedAnimation(Colors.red);
                    } else {
                      color = AlwaysStoppedAnimation(Colors.blue);
                    }
                  }
                  return LiquidCustomProgressIndicator(
                    value: level, // Defaults to 0.5.
                    valueColor:
                        color, // Defaults to the current Theme's accentColor.
                    backgroundColor: const Color.fromARGB(255, 130, 123,
                        123), // Defaults to the current Theme's backgroundColor.
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                    shapePath:
                        _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                    //var percentage,

                    center: Text(
                      "${percentage.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 48, 40, 40),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
            StreamBuilder(
                stream: stream1,
                builder: (ctx, AsyncSnapshot<GraphData> snapshot) {
                  if (snapshot.hasData) {
                    globals.inFlow.add(snapshot.data!);
                  }
                  return Card(
                      color: themeColor(),
                      child: Column(
                        children: [
                          InkWell(
                            splashColor: Colors.grey.withOpacity(0.4),
                            onTap: () {
                              onTapExpand(
                                  context,
                                  Graph(
                                      graphTitle: 'In-flow',
                                      data: globals.inFlow));
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
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 5),
                                        child:
                                            Icon(Icons.open_in_full, size: 20),
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
                                data: globals.inFlow,
                              )),
                        ],
                      ));
                }),
            //
            //
            //
            //
            //

            StreamBuilder(
                stream: stream2,
                builder: (ctx, AsyncSnapshot<GraphData> snapshot) {
                  if (snapshot.hasData) {
                    globals.outFlow.add(snapshot.data!);
                  }
                  return Card(
                      color: themeColor(),
                      child: Column(
                        children: [
                          InkWell(
                            splashColor: Colors.grey.withOpacity(0.4),
                            onTap: () {
                              onTapExpand(
                                  context,
                                  Graph(
                                      graphTitle: 'Out-flow',
                                      data: globals.outFlow));
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
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 5),
                                        child:
                                            Icon(Icons.open_in_full, size: 20),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                              height: 180,
                              width: 400,
                              child: Graph(
                                graphTitle: 'Out-flow',
                                data: globals.outFlow,
                              )),
                        ],
                      ));
                }),

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

    List<String> splittedIn = inflowFromfile.split(" ");
    List<String> splittedOut = outflowFromfile.split(" ");
    List<String> splittedTank = tankFromfile.split(" ");
    List<GraphData> inf = <GraphData>[];
    List<GraphData> outf = <GraphData>[];

    print(splittedIn);

    for (int i = 0; i < 30; i++) {
      Indata.add(double.parse(splittedIn[i]));
      Outdata.add(double.parse(splittedOut[i]));
      globals.Tankdata.add(double.parse(splittedTank[i]));
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
      graphLable1[formattedDate] = 0;
      graphLable2[formattedDate] = 0;
    }

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable1.entries) {
      inf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable2.entries) {
      outf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    setState(() {
      globals.inFlow = inf;
      globals.outFlow = outf;
    });

    //return dataTest;
  }

  void threshold(double water_level) {
    if (water_level == 0) {
      globals.noWaterCount++;
    }

    water_level = (water_level / 1500) * 100;

    if (water_level <= 20 && checkerL == true) {
      globals.lowerCount++;
      if (globals.NotificationState) {
        pushNoteApi('Low threshold', 'Your water tank is Low');
      }
      checkerL = false;
      checkerU = true;
    } else if (water_level >= 95 && checkerU == true) {
      globals.upperCount++;
      if (globals.NotificationState) {
        pushNoteApi('Upper threshold', 'Your water tank is almost full');
      }
      checkerU = false;
      checkerL = true;
    } else if (water_level > 20 && water_level < 95) {
      checkerU = true;
      checkerL = true;
    }
    print(
        "Lower count: ${globals.lowerCount}, Upper count: ${globals.upperCount}, No water count: ${globals.noWaterCount}");
  }

  Widget buildimage() => SizedBox(
        width: 100,
        height: 200,
        child: Graph(graphTitle: 'In-flow', data: globals.inFlow),
      );
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
