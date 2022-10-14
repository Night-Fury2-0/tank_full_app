import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> _createPDF() async {
  //Create a PDF document.
  var document = PdfDocument();
  //Add page and draw text to the page.
  document.pages.add().graphics.drawString(
      'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 18),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(0, 0, 500, 30));
  //Save the document
  var bytes = document.save();
  // Dispose the document
  document.dispose();
  //Get external storage directory
  Directory directory = (await getApplicationDocumentsDirectory());
  //Get directory path
  String path = directory.path;
  //Create an empty file to write PDF data
  File file = File('$path/Output.pdf');
  //Write PDF data
  await file.writeAsBytes(bytes, flush: true);
  //Open the PDF document in mobile
  OpenFile.open('$path/Output.pdf');
}

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Download Screen'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createPDF,
        label: Text('Download Pdf'),
        icon: const Icon(Icons.download),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}
