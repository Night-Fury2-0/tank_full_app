import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'globals.dart' as globals;

import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Settings Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

            ElevatedButton(
              onPressed: () {
                globals.NotificationState = false;
              },

              child: Text('Notification'),
            ),
            //


        ],
      ),
    );
  }
}
