import 'dart:io';
import 'package:flutter/services.dart';

Future<String> copyModelFromAssets(String assetPath) async {
  final data = await rootBundle.load(assetPath);

  final file = File('/tmp/model.tflite');

  await file.writeAsBytes(data.buffer.asUint8List());

  return file.path;
}
