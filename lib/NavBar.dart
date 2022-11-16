import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'download_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'globals.dart' as globals;
import 'line_chart.dart';

class NavBar extends StatelessWidget {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          //This tile points to null so that we could use it
          //as an empty bar at the top of the navigation bar
          ListTile(
            tileColor: Colors.blue,
            onTap: () => null,
          ),

          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              }),

          ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export'),
              onTap: () async {
                getInGraph();
                getOutGraph();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DownloadScreen(
                            waiting1: getInGraph(),
                            waiting2: getOutGraph(),
                          )),
                );
              }),

          ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()),
                    )
                  }),
          ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              }),
          ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              }),
          const Divider(),
          ListTile(
            title: const Text('Report Bug'),
            leading: const Icon(Icons.bug_report),
            onTap: () => reportBug(),
          ),
          const Divider(),
          ListTile(
              title: const Text('Exit'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => {
                    if (defaultTargetPlatform == TargetPlatform.android)
                      {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop')
                      }
                    else
                      {exit(0)}
                  }),
          const Divider(),
        ],
      ),
    );
  }

  Future<bool> getInGraph() async {
    globals.imageInFlow = await screenshotController.captureFromWidget(SizedBox(
        height: 180,
        width: 400,
        child: MaterialApp(
          home: Graph(
            graphTitle: 'In-flow',
            data: globals.inFlow,
          ),
        )));
    return true;
  }

  Future<bool> getOutGraph() async {
    globals.imageOutFlow =
        await screenshotController.captureFromWidget(SizedBox(
            height: 180,
            width: 400,
            child: MaterialApp(
              home: Graph(
                graphTitle: 'Out-flow',
                data: globals.outFlow,
              ),
            )));
    return true;
  }
}

//Funtion to call Instabug which is the package used for the bug reporting feature
void reportBug() {
  Instabug.show();
}
