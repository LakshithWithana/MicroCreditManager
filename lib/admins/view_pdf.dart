import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

import '../shared/colors.dart';

class ViewPDFArgs {
  final PDFDocument doc;

  ViewPDFArgs({required this.doc});
}

class ViewPDF extends StatefulWidget {
  const ViewPDF({Key? key}) : super(key: key);

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ViewPDFArgs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview",
          style: TextStyle(color: mainColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: accentColor, //change your color here
        ),
      ),
      body: Center(child: PDFViewer(document: args.doc)),
    );
  }
}
