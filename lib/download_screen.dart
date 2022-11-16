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
  
  final Output test = Output('September-October');
  DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final Filepath =
  path() ;
  

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
                builder: (context) => PdfPreviewPage(test: test)));
          },
          label: Text('Export Pdf'),
          icon: const Icon(Icons.download),
        ),

        //Everything insinde body is what shows on the download page.
        //Must be generally the same as the pdf_export layout.
        body: ListView(
          children: [Padding(padding: EdgeInsets.all(15.0), child: Text(test.period)),
          //Display In Flow Screenshot
          Card(child:Image.memory(globals.imageInFlow) ,),
          //Display Out Flow Screenshot
          Card(child:Image.memory(globals.imageOutFlow))
          
          ],
        ));
  }

path() async {

var tempDir = await getExternalStorageDirectory();
var filepath1 = "${tempDir!.path}/test1.png";

  return filepath1;
}




}

