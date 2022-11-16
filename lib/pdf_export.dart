import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'globals.dart';

import 'pdf_data.dart';

final Output Display = Output('September-October','5','8','9');

final inflowIMG = MemoryImage(imageInFlow);
final outflowIMG = MemoryImage(imageOutFlow);


//Function to actually create the pdf.
Future<Uint8List> makePdf(Output data) async {
  final pdf = Document();
  pdf.addPage(Page(
      //pageFormat: PdfPageFormat.a4,
      build: (context) {
    return ListView(
      //Everything insinde here is what shows on the exported pdf.
      //Must be generally the same as the download screen's body layout.
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child:Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(Display.period,style: TextStyle(fontSize: 14)),
          Text(Display.lowAlerts,style: TextStyle(fontSize: 14)),
          Text(Display.highAlerts, style: TextStyle(fontSize: 14)), 
          Text(Display.noWaterDays, style: TextStyle(fontSize: 14))]
          ) ,
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Image(inflowIMG),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Image(outflowIMG),
        )
      ],
    );
  }));

  return pdf.save();
}
