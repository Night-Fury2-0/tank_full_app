import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'download_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';
import 'help_screen.dart';
import 'package:http/http.dart' as http;
import 'package:instabug_flutter/instabug_flutter.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            //leading: Icon(Icons.favorite),
            //title: Text(''),
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
              title: const Text('Download'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadScreen()),
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
}


void reportBug(){
  Instabug.show();
  
}
