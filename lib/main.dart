import 'dart:async';
import 'dart:collection';
import 'help_screen.dart';

import 'package:flutter/material.dart';
import 'package:libserialport/libserialport.dart';
import 'package:usb_serial/usb_serial.dart';

import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

void main() {
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tank-Full'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var level1 = 0.0;
  var level2 = 0.0;

  void usb_data() {
    var datalist = [];

    List<String> availablePorts = SerialPort.availablePorts;
    print("Ports: ");
    print(availablePorts);

    //var COMport = findCOMport(availablePorts);
    //print("Port: " + COMport);

    SerialPort port1 = SerialPort("COM5");
    port1.openRead();
    var config = SerialPortConfig();
    config.baudRate = 9600;
    port1.config = config;

    SerialPortReader reader = SerialPortReader(port1);

    StreamController<String> controller = StreamController<String>.broadcast();
    reader.stream.listen((data) {
      String dataString = String.fromCharCodes(data);
      controller.add(dataString);
    });

    controller.stream.listen((data) {
      print("Read data: $data");

      if (data.contains("\n") || data.contains("\r")) {
        print("Found");
        data = data.replaceAll("\n", "");
        data = data.replaceAll("\r", "");
        print(data);
      }

      if (data != "\n" && data != "\r" && data != "") {
        datalist.add(double.parse(data));
      }

      print(datalist);

      if (datalist.length == 2) {
        setState(() {
          level1 = datalist[0];
          level2 = datalist[1];
        });

        datalist.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    usb_data();
  }

  @override
  Widget build(BuildContext context) {
    //Initialise variables and colours for the tank

    var percentage1 = level1 * 100;
    var color1;
    if (level1 <= 0.25) {
      color1 = const AlwaysStoppedAnimation(Colors.red);
    } else {
      color1 = const AlwaysStoppedAnimation(Colors.blue);
    }

    var percentage2 = level2 * 100;
    var color2;
    if (level2 <= 0.25) {
      color2 = const AlwaysStoppedAnimation(Colors.red);
    } else {
      color2 = const AlwaysStoppedAnimation(Colors.blue);
    }
    return Scaffold(
      //drawer: NavBar(), //Calls navbar function on homepage
      //onDrawerChanged: (isOpened) async {},
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
          //Adds the shortcut to Help page on appbar
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
                child: const Icon(Icons.help),
              )),
        ],
      ),

      //Future builder used to wait for the a, b, and c to retrieve data from files before loading homepage
      body: Center(
          child: Column(
        //alignment: Alignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Single child scroll used to scroll the homepage

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //Tank 1

              Container(
                child: Column(children: [
                  LiquidCustomProgressIndicator(
                    value: level1,
                    valueColor:
                        color1, // Defaults to the current Theme's accentColor.
                    backgroundColor: const Color.fromARGB(255, 130, 123,
                        123), // Defaults to the current Theme's backgroundColor.
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                    shapePath:
                        _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                    //var percentage,

                    center: Text(
                      "${percentage1.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 238, 238, 238),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text("Tank 1"),
                ]),
              ),

              //Tank 2
              Container(
                child: Column(children: [
                  LiquidCustomProgressIndicator(
                    value: level2,
                    valueColor:
                        color2, // Defaults to the current Theme's accentColor.
                    backgroundColor: const Color.fromARGB(255, 130, 123,
                        123), // Defaults to the current Theme's backgroundColor.
                    direction: Axis
                        .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right).
                    shapePath:
                        _buildBoatPath(), // A Path object used to draw the shape of the progress indicator. The size of the progress indicator is created from the bounds of this path.
                    //var percentage,

                    center: Text(
                      "${percentage2.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 238, 238, 238),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text("Tank 2"),
                ]),
              ),
            ],
          )
        ],
      )
          //return const CircularProgressIndicator();
          ),
    );
  }
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

void usb_data() {
  List<String> availablePorts = SerialPort.availablePorts;
  print("Ports: ");
  print(availablePorts);

  //var COMport = findCOMport(availablePorts);
  //print("Port: " + COMport);

  SerialPort port1 = SerialPort("COM3");
  port1.openRead();
  var config = SerialPortConfig();
  config.baudRate = 9600;
  port1.config = config;

  SerialPortReader reader = SerialPortReader(port1);

  StreamController<String> controller = StreamController<String>.broadcast();
  reader.stream.listen((data) {
    String dataString = String.fromCharCodes(data);
    controller.add(dataString);
  });

  controller.stream.listen((data) {
    print("Read data: $data");
  });
}

//This is the working 1!!!!///////////////////////////////////////////////
/*void usb_data() {
  List<String> availablePorts = SerialPort.availablePorts;
  print("Ports: ");
  print(availablePorts);

  //var COMport = findCOMport(availablePorts);
  //print("Port: " + COMport);

  SerialPort port1 = SerialPort("COM3");
  port1.openRead();
  var config = SerialPortConfig();
  config.baudRate = 9600;
  port1.config = config;

  SerialPortReader reader = SerialPortReader(port1);
  Stream<String> readData = reader.stream.map((data) {
    return String.fromCharCodes(data);
  });

  readData.listen((data) {
    print("Read data: $data");
  });
}*/
/////////////////////////////////////////////////////////////////////////////

/*void usb_data() async {
  List<UsbDevice> devices = await UsbSerial.listDevices();
  print("Devices: ");
  print(devices);

  UsbDevice device = devices.firstWhere(
    (d) => d.productName!.contains('COM3'),
    orElse: () => devices[0],
  );

  if (device != null) {
    UsbPort? port = await device.create();

    await port?.setDTR(true);
    await port?.setRTS(true);
    await port?.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    port?.inputStream?.listen((data) {
      String message = String.fromCharCodes(data);
      print('Received message: $message');
    });
    port?.close();
  }
}*/

String findCOMport(List<String> availablePorts) {
  late String port = '';
  for (var i = 0; i < availablePorts.length; i++) {
    SerialPort temp = SerialPort(availablePorts[i]);

    print(availablePorts[i]);

    if (temp.vendorId != null || temp.productId != null) {
      if (temp.vendorId!.toRadixString(16) == "2e8a" &&
          temp.productId!.toRadixString(16) == "5") {
        port = availablePorts[i];
      } else {
        port = "";
        throw Exception("Device wasn't found");
      }
    } else {
      continue;
    }
  }

  return port;
}
