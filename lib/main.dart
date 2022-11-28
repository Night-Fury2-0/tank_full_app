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
import 'dart:developer';
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
          // This is the theme of your application
          brightness: themeMode()),
      home: MyHomePage(title: 'Tank-Full'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Paths for tank shape
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
  //Create an instance of ScreenshotController. The screenshot controller is called when a screenshot needs to be taken
  ScreenshotController screenshotController = ScreenshotController();

//Zeros used to initialise the strings. These strings are used to store data retrieved from textfiles.
  String inflowFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
  String outflowFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
  String tankFromfile =
      "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";

//These lists are used to store the Liter data values for in and out flow
//They are then pushed into the "liter" member of the "GraphData" class
  List<double> Indata = [];
  List<double> Outdata = [];

  //var water_level = 0.0;
  //Checkers used for upper and lower thresholds to make sure they don't send consecutively
  bool checkerL = true;
  bool checkerU = true;

  //Reads data from inflow text file
  Future<String> getData1() async {
    String inflowFromfile =
        await rootBundle.loadString('assets/InFlowData.txt');
    return inflowFromfile;
  }

  //Reads data from outflow text file
  Future<String> getData2() async {
    String outflowFromfile =
        await rootBundle.loadString('assets/OutFlowData.txt');
    return outflowFromfile;
  }

  //Reads data from tank level text file
  Future<String> getData3() async {
    String tankFromfile =
        await rootBundle.loadString('assets/TankLevelData.txt');
    return tankFromfile;
  }

  //Creates a stream for the first graph to load every 2 seconds
  Stream<GraphData> inputData() async* {
    for (int i = 0; i < 30; i++) {
      var now = DateTime.now();
      //Formats the data to Month-Day
      var formatter = DateFormat('dd-MM');
      //Gets past 30 days using 'i'
      var date = DateTime(now.year, now.month, now.day + i + 1);

      //Creates string of the date and formats it
      String formattedDate = formatter.format(date);

      await Future<void>.delayed(const Duration(seconds: 2));
      globals.inFlow.removeAt(0);
      //inspect(globals.inFlow);
      print('In: ${i}');
      yield GraphData(formattedDate, Indata[i]);
    }

    //Pushes the 29th index because the loop wasn't doing that for some reason
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM');
    var date = DateTime(now.year, now.month, now.day + 30);
    String formattedDate = formatter.format(date);
    yield GraphData(formattedDate, Indata[29]);
  }

  //Creates a stream for the second graph to load every 2 seconds
  Stream<GraphData> outputData() async* {
    for (int i = 0; i < 30; i++) {
      var now = DateTime.now();
      //Formats the data to Month-Day
      var formatter = DateFormat('dd-MM');
      //Gets past 30 days using 'i'
      var date = DateTime(now.year, now.month, now.day + i + 1);

      //Creates string of the date and formats it
      String formattedDate = formatter.format(date);

      await Future<void>.delayed(const Duration(seconds: 2));
      globals.outFlow.removeAt(0);
      print("Out: ${globals.outFlow[i].liter}");
      yield GraphData(formattedDate, Outdata[i]);
    }

    //Pushes the 29th index because the loop wasn't doing that for some reason
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM');
    var date = DateTime(now.year, now.month, now.day + 30);
    String formattedDate = formatter.format(date);
    yield GraphData(formattedDate, Outdata[29]);
  }

  //Creates a stream to load tank data every 2 seconds
  Stream<dynamic> gettankData() async* {
    for (int i = 0; i < 30; i++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      print("Tank: ${globals.Tankdata[i]}");
      threshold(globals.Tankdata[i]);
      //print(globals.Tankdata);
      yield (globals.Tankdata[i] / 1500);
    }
  }

  late StreamBuilder myStream;

  //Initilizes the instabug package which is used for the bug reporting feature
  @override
  void initState() {
    //Instabug.start takes the key for the Instabug account and what you want to use to trigger the pakage
    //Currently the key is set for apps in debug mode, not the live one
    Instabug.start('144c393c30a9ca42526659d95264c2d6', [InvocationEvent.none]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Turns the stream broadcasts into variables for easier use
    Stream<GraphData> stream1 = inputData().asBroadcastStream();
    Stream<GraphData> stream2 = outputData().asBroadcastStream();
    Stream<dynamic> stream3 = gettankData().asBroadcastStream();

    //Variables used to store future strings returned from text files
    Future<String> a = getData1();
    Future<String> b = getData2();
    Future<String> c = getData3();

    //Initialise variables and colours for the graph
    var level = 0.0;
    var percentage = level * 100;
    var color;
    if (level <= 0.25) {
      color = const AlwaysStoppedAnimation(Colors.red);
    } else {
      color = const AlwaysStoppedAnimation(Colors.blue);
    }

    return Scaffold(
        drawer: NavBar(), //Calls navbar function on homepage
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
            //Adds the shortcut to settings page on appbar
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
            //Adds the shortcut to Help page on appbar
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpScreen()),
                    );
                  },
                  child: const Icon(Icons.help),
                )),
          ],
        ),
        //Future builder used to wait for the a, b, and c to retrieve data from files before loading homepage
        body: FutureBuilder<List<String>>(
            future: Future.wait([a, b, c]), //waits for a,b, and c
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                //snapshot stores the data, i think.
                //The data stored in snapshot is then pushed to each string
                inflowFromfile = snapshot.data![0];
                outflowFromfile = snapshot.data![1];
                tankFromfile = snapshot.data![2];
                //function to convert strings to double and put it into GraphData class
                getList();

                return Column(
                  //alignment: Alignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Single child scroll used to scroll the homepage
                    SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Tank widget and graph widgets go inside this "children" container(?)

                        StreamBuilder(
                            stream: stream3, //Uses the stream for the tank
                            builder:
                                (context, AsyncSnapshot<dynamic> snapshot1) {
                              if (snapshot1.hasData) {
                                //sets the water level and percentange based of snapshot
                                level = snapshot1.data!;
                                percentage = level * 100;
                                if (level <= 0.20) {
                                  color =
                                      const AlwaysStoppedAnimation(Colors.red);
                                } else {
                                  color =
                                      const AlwaysStoppedAnimation(Colors.blue);
                                }
                              }
                              return LiquidCustomProgressIndicator(
                                value: level,
                                valueColor:
                                    color, // Defaults to the current Theme's accentColor.
                                backgroundColor: const Color.fromARGB(
                                    255,
                                    130,
                                    123,
                                    123), // Defaults to the current Theme's backgroundColor.
                                direction: Axis
                                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                                shapePath:
                                    _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                                //var percentage,

                                center: Text(
                                  "${percentage.toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),

                        //Stream builder used for first graph
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
                                        splashColor:
                                            Colors.grey.withOpacity(0.4),
                                        onTap: () {
                                          //Opens the graph on new page with fullscreen page
                                          onTapExpand(
                                              context,
                                              Graph(
                                                  graphTitle: 'In-flow',
                                                  data: globals.inFlow));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.transparent,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 5, 5),
                                                    child: Icon(
                                                        Icons.open_in_full,
                                                        size: 20),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Container(
                                          height: 200,
                                          //width: 480,
                                          child: Graph(
                                            graphTitle: 'In-flow',
                                            data: globals.inFlow,
                                          )),
                                    ],
                                  ));
                            }),

                        //Stream builder used for second graph
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
                                        splashColor:
                                            Colors.grey.withOpacity(0.4),
                                        onTap: () {
                                          onTapExpand(
                                              context,
                                              Graph(
                                                  graphTitle: 'Out-flow',
                                                  data: globals.outFlow));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: Colors.transparent,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 5, 5),
                                                    child: Icon(
                                                        Icons.open_in_full,
                                                        size: 20),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      Container(
                                          height: 200,
                                          //width: 400,
                                          child: Graph(
                                            graphTitle: 'Out-flow',
                                            data: globals.outFlow,
                                          )),
                                    ],
                                  ));
                            }),
                      ],
                    ))
                  ],
                );
              }
              return const CircularProgressIndicator();
            }));
  }

  void getList() {
    //Maps date and liter
    Map<String, double> graphLable1 = {};
    Map<String, double> graphLable2 = {};

    //Spilts string accepted from data
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

    print(graphLable1);

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable1.entries) {
      inf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    //Populate list with the dates and values from the map
    for (final mapEntry in graphLable2.entries) {
      outf.add(GraphData(mapEntry.key, mapEntry.value));
    }

    globals.inFlow = inf;
    globals.outFlow = outf;

    //return dataTest;
  }

//checks if there was no water for the day
//increments a counter to track the number of days without water
  void threshold(double water_level) {
    if (water_level == 0) {
      globals.noWaterCount++;
    }

    //calculates the water level as a percent for a 1500L tank
    water_level = (water_level / 1500) * 100;

    //Checks if the water level is below 20% and the lower checker is true
    //increments a low level counter to count the number of days with low levels
    if (water_level <= 20 && checkerL == true) {
      globals.lowerCount++;

      //Calls a function to call an API which will push the notification
      if (globals.NotificationState) {
        //function for the API which takes in the title and message of the notification as arguments
        pushNoteApi('Low threshold', 'Your water tank is Low');
      }
      checkerL = false;
      checkerU = true;

      //Checks if the water level is above 95% and the upper checker is true
      //increments an upper level counter to count the number of days with high levels
    } else if (water_level >= 95 && checkerU == true) {
      globals.upperCount++;

      //Calls a function to call an API which will push the notification
      if (globals.NotificationState) {
        //function for the API which takes in the title and message of the notification as arguments
        pushNoteApi('Upper threshold', 'Your water tank is almost full');
      }
      checkerU = false;
      checkerL = true;

      //checks if water level is in a normal above 20% and below 95%
    } else if (water_level > 20 && water_level < 95) {
      checkerU = true;
      checkerL = true;
    }
    print(
        "Lower count: ${globals.lowerCount}, Upper count: ${globals.upperCount}, No water count: ${globals.noWaterCount}");
  }
  /*
  Widget buildimage() => SizedBox(
        width: 100,
        height: 200,
        child: Graph(graphTitle: 'In-flow', data: globals.inFlow),
      );*/ //Needs to be removed if code works
}

//Function that calls the API used for the push notifications
//Sets up the structure of the notification by taling in the title and body of the notification.
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

//Function of type brightness which returns a variable of type brightness
//if it is true it would return a dark theme else it would return light mode
Brightness themeMode() {
  if (globals.ThemeMode) {
    return Brightness.dark;
  } else {
    return Brightness.light;
  }
}

//Function of type colour which returns a variable of type colour
//if it is true it would return one mapping of colours else it would return a different mapping of colours
Color themeColor() {
  if (globals.ThemeMode) {
    return const Color.fromARGB(255, 48, 49, 48);
  } else {
    return const Color.fromARGB(255, 250, 250, 249);
  }
}
