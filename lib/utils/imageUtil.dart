import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class ImageUtils {
  static capture(GlobalKey key) async {
    RenderRepaintBoundary? boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }

    final image = await boundary.toImage(pixelRatio: 3);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    final pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }
}
