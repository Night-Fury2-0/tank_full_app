import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_switch/flutter_switch.dart';
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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Adds text telling the user the setting option
          //formats the text on the screen in a column and using padding
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

                  //Creates the toggle switch for the setting
                  //formats the position of the toggle switch on the screen
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: FlutterSwitch(
                      //calls the package used for the toggle switch
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

          //Adds text telling the user the setting option
          //formats the text on the screen in a column and using padding
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

                  //Creates the toggle switch for the setting
                  //formats the position of the toggle switch on the screen
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: FlutterSwitch(
                      //calls the package used for the toggle switch
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
