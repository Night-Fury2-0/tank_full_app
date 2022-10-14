import 'package:flutter/material.dart';
import 'package:water_v3/pdf_previewer.dart';
import 'NavBar.dart';
import 'pdf_data.dart';

class DownloadScreen extends StatelessWidget {
  final Output test = Output('September-October');
  DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text('Download Screen'),
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
