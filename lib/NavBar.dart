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
          //this tile is set to blue to match the app bar in the app
          ListTile(
            tileColor: Colors.blue,
            onTap: () => null,
          ),

          //Home tile
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              }),

          //Export tile
          ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export'),
              onTap: () async {
                //When the user clicks on the tile to open the downloads page,
                //these functions are called to take a screenshot of the graphs from the first page
                getInGraph();
                getOutGraph();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DownloadScreen(
                            //Waits for the screenshot to be taken and the funtion to return true before the graphs are loaded
                            //This allows for the download screen to load before the screenshots are taken since it takes a few seconds for the screen shot to occur
                            waiting1: getInGraph(),
                            waiting2: getOutGraph(),
                          )),
                );
              }),

          //About tile
          ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),

              //opens into the About page (which will be built and formatted from the about_screen.dart file)
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()),
                    )
                  }),

          //Settings screen
          ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              //opens into the Settings page (which will be built and formatted from the setting_screen.dart file)
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              }),

          //Help screen
          ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              //opens into the Help page (which will be built and formatted from the help_screen.dart file)
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              }),

          const Divider(),

          //Calls the reportBug funtion when the user clicks in this tile in the nav bar
          ListTile(
            title: const Text('Report Bug'),
            leading: const Icon(Icons.bug_report),
            onTap: () => reportBug(),
          ),

          const Divider(),

          //Exit tile
          //when clicked it will close the app
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

//Funtion to take the screenshot of the In Flow graph from the home page
  Future<bool> getInGraph() async {
    //Calls the screenshot controller to actually take the screenshot of the graph
    //and assigns the image to a static variable(teachnically a global variable but not really)
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

//Funtion to take the screenshot of the Out Flow graph from the home page
  Future<bool> getOutGraph() async {
    //Calls the screenshot controller to actually take the screenshot of the graph
    //and assigns the image to a static variable(teachnically a global variable but not really)
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
  //Instead of usning one of the invocation event, we used instabug.show to call the popup for the bug reporting
  Instabug.show();
}
