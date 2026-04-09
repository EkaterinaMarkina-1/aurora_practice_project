// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'dart:async';

// import 'package:ffi_plugin/ffi_plugin.dart'; // твой локальный FFI плагин

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool modelLoaded = false;
//   int? inferenceResult;

//   @override
//   void initState() {
//     super.initState();
//     _loadModelAndRunInference();
//   }

//   Future<void> _loadModelAndRunInference() async {
//     const modelPath = 'assets/models/model_float32.tflite';

//     // Попытка загрузки модели через FFI плагин
//     final loaded = loadModel(modelPath);
//     if (!loaded) {
//       print('❌ Failed to load model: $modelPath');
//       return;
//     }

//     print('✅ Model loaded: $modelPath');
//     setState(() {
//       modelLoaded = true;
//     });

//     // Генерируем dummy PCM данные (1 секунда аудио 16 kHz, все нули)
//     final pcmData = Int16List.fromList(List.filled(16000, 0));

//     // Асинхронно делаем инференс
//     final result = await runInferenceAsync(pcmData);

//     print('🎯 Inference result: $result');

//     setState(() {
//       inferenceResult = result;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('TFLite FFI Demo')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Model loaded: $modelLoaded',
//                 style: const TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 inferenceResult != null
//                     ? 'Inference result index: $inferenceResult'
//                     : (modelLoaded
//                         ? 'Running inference...'
//                         : 'Loading model...'),
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
