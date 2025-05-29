import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DropboxPreviewPage extends StatefulWidget {
  final String imagePath;  // rename url to imagePath to clarify it's a file path

  const DropboxPreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<DropboxPreviewPage> createState() => _DropboxPreviewPageState();
}

class _DropboxPreviewPageState extends State<DropboxPreviewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    _loadLocalImage(widget.imagePath);
  }

  Future<void> _loadLocalImage(String path) async {
    final bytes = await File(path).readAsBytes();
    final base64Image = base64Encode(bytes);
    final htmlContent = '''
      <html>
        <body style="margin:0;padding:0;">
          <img src="data:image/jpeg;base64,$base64Image" style="width:100%;height:auto;" />
        </body>
      </html>
    ''';

    controller.loadRequest(
      Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proof of your work!!')),
      body: WebViewWidget(controller: controller),
    );
  }
}
