import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tankfull_app/pdf_previewer.dart';
import 'NavBar.dart';
import 'pdf_data.dart';
import 'globals.dart' as globals;
import 'settings_screen.dart';
import 'help_screen.dart';

class DownloadScreen extends StatelessWidget {
  Future<bool> waiting1;
  Future<bool> waiting2;
  final Output Display = Output(globals.lowerCount.toString(),
      globals.upperCount.toString(), globals.noWaterCount.toString());
  DownloadScreen({super.key, required this.waiting1, required this.waiting2});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: NavBar(),
        appBar: AppBar(
          title: const Text('Export'),
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
                      MaterialPageRoute(
                          builder: (context) => const HelpScreen()),
                    );
                  },
                  child: Icon(Icons.help),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PdfPreviewPage(test: Display)));
          },
          label: Text('Export Pdf'),
          icon: const Icon(Icons.download),
        ),

        //Everything insinde body is what shows on the download page.
        //Must be generally the same as the pdf_export layout.
        body: FutureBuilder(
          future: Future.wait([waiting1, waiting2]),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(Display.period,
                                    style: TextStyle(fontSize: 16))),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(Display.lowAlerts,
                                    style: TextStyle(fontSize: 16))),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(Display.highAlerts,
                                    style: TextStyle(fontSize: 16))),
                            Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(Display.noWaterDays,
                                    style: TextStyle(fontSize: 16)))
                          ])),
                  //Display In Flow Screenshot
                  Card(
                    child: Image.memory(globals.imageInFlow),
                  ),
                  //Display Out Flow Screenshot
                  Card(child: Image.memory(globals.imageOutFlow))
                ],
              );
            } else {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  ]);
            }
          }),
        ));
  }
}
