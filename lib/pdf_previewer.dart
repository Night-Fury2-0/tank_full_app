import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:printing/printing.dart';

import 'pdf_export.dart';
import 'pdf_data.dart';

//This is the Preview page of the pdf export

class PdfPreviewPage extends StatelessWidget {
  final Output test;
  const PdfPreviewPage({Key? key, required this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        //passes the makePdf funtion, and the data output object
        build: (context) => makePdf(test),
      ),
    );
  }
}
