import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'globals.dart' as globals;
import 'package:flutter_switch/flutter_switch.dart';
import 'help_screen.dart';
import 'main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 15, 0),
                    child: Text("Allow Push Notification",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: FlutterSwitch(
                      width: 60.0,
                      height: 35.0,
                      valueFontSize: 16.0,
                      toggleSize: 15.0,
                      value: globals.NotificationState,
                      borderRadius: 30.0,
                      padding: 6.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          globals.NotificationState = val;
                        });
                      },
                    ),
                  )
                ],
              )),
          Card(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 15, 0),
                    child: Text("Enable Dark mode",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: FlutterSwitch(
                      width: 60.0,
                      height: 35.0,
                      valueFontSize: 16.0,
                      toggleSize: 15.0,
                      value: globals.ThemeMode,
                      borderRadius: 30.0,
                      padding: 6.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          globals.ThemeMode = val;
                        });
                        runApp(MaterialApp(home: MyApp()));
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
