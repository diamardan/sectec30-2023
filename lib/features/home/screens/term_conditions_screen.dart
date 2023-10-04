import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermConditionsScreen extends StatelessWidget {
  TermConditionsScreen({super.key});

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aviso de privacidad')),
      body: SfPdfViewer.network(
        'https://datamex1.com/AVISO%20PRIVACIDAD%20datamex.pdf',
        key: _pdfViewerKey,
      ),
    );
  }
}
