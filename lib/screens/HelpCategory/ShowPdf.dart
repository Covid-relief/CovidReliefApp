import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PDF extends StatefulWidget {
  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  String pdfasset = "assets/guideapp.pdf";
  PDFDocument doc;
  bool loading;

  @override
  void initState() {
    super.initState();
    initPdf();
  }

  initPdf() async {
    setState(() {
      loading = true;
    });
    final doc1 = await PDFDocument.fromAsset(pdfasset);
    print(doc1);
    setState(() {
      doc = doc1;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guía para ayudar"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: doc,
              indicatorBackground: Colors.red,
              // showIndicator: false,
              // showPicker: false,
            ),
    );
  }
}
