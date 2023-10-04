import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
/* 
class RenderCredentialScreen extends StatelessWidget {
  final String pdfPath;
  const RenderCredentialScreen({this.pdfPath, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PdfView(path: pdfPath);
  }
} */

class RenderCredentialScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;

  RenderCredentialScreen({required this.pdfPath, required this.pdfName})
      : super();

  @override
  _RenderCredentialScreenState createState() => _RenderCredentialScreenState();
}

class _RenderCredentialScreenState extends State<RenderCredentialScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () async {
              final pdfName = widget.pdfName;
              final xFiles = [
                XFile(
                  widget.pdfPath,
                  name: pdfName,
                )
              ];
              Share.shareXFiles(
                xFiles,
                text: "Ésta es mi credencial digital $pdfName",
                subject: pdfName, // Agrega el nombre del PDF como sujeto,
              );
              //    text: "Ésta es mi credencial digital");
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File(this.widget.pdfPath),
        key: _pdfViewerKey,
      ),
    );
  }
}
