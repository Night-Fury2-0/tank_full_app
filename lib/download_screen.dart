import 'package:flutter/material.dart';
import 'package:tankfull_app/pdf_previewer.dart';
import 'NavBar.dart';
import 'pdf_data.dart';

import 'settings_screen.dart';
import 'help_screen.dart';

class DownloadScreen extends StatelessWidget {
  final Output test = Output('September-October');
  DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: NavBar(),
        appBar: AppBar(
          title: const Text('Download Screen'),
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
                builder: (context) => PdfPreviewPage(test: test)));
          },
          label: Text('Download Pdf'),
          icon: const Icon(Icons.download),
        ),

        //Everything insinde body is what shows on the download page.
        //Must be generally the same as the pdf_export layout.
        body: ListView(
          children: [
            Padding(padding: EdgeInsets.all(15.0), child: Text(test.period))
          ],
        ));
  }
}
