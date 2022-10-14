import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'pdf_data.dart';

final Output test = Output('September-October');

//Function to actually create the pdf.
Future<Uint8List> makePdf(Output data) async {
  final pdf = Document();
  pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return ListView(
          //Everything insinde here is what shows on the exported pdf.
          //Must be generally the same as the download screen's body layout.
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(test.period),
            )
          ],
        );
      }));

  return pdf.save();
}
