import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:ffi_plugin/ffi_plugin.dart';

class VoiceService {
  bool isListening = false;
  double audioLevel = 0;
  int? inferenceResult;

  bool _isInitialized = false;
  bool _ffiInitialized = false;

  Timer? _timer;

  static const String MODEL_FLOAT32 = 'float32';
  static const String MODEL_FLOAT16 = 'float16';
  static const String MODEL_INT8 = 'int8';

  String _selectedModelType = MODEL_FLOAT32;

  File? _currentModelFile;

  String get selectedModelType => _selectedModelType;

  Future<void> _initFfi() async {
    if (_ffiInitialized) return;

    print("🔌 Initializing FFI plugin...");

    try {
      await initFfiPlugin(); 
      _ffiInitialized = true;
      print("✅ FFI initialized");
    } catch (e) {
      print("❌ FFI init failed: $e");
      rethrow;
    }
  }

  void setModelType(String type) {
    if ([MODEL_FLOAT32, MODEL_FLOAT16, MODEL_INT8].contains(type)) {
      _selectedModelType = type;
      print("Model type set to: $type");
    } else {
      print("Invalid model type: $type");
    }
  }

  String _getAssetPath() {
    switch (_selectedModelType) {
      case MODEL_FLOAT32:
        return 'assets/models/model_float32.tflite';
      case MODEL_FLOAT16:
        return 'assets/models/model_float16.tflite';
      case MODEL_INT8:
        return 'assets/models/model_int8.tflite';
      default:
        return 'assets/models/model_float32.tflite';
    }
  }

  Future<bool> initModel() async {
    final assetPath = _getAssetPath();

    try {
      print("Loading model: $assetPath (type: $_selectedModelType)");
      await _initFfi();

      final data = await rootBundle.load(assetPath);
      final file = File('/tmp/model_${_selectedModelType}.tflite');
      await file.writeAsBytes(data.buffer.asUint8List());

      if (!await file.exists()) {
        print("File NOT found after write!");
        return false;
      }

      print("File exists: ${file.path}");
      print("File size: ${await file.length()} bytes");

      _currentModelFile = file;

      print("Calling loadModel from FFI...");
      final loaded = await loadModel(file.path);

      if (loaded) {
        print("✅ Model loaded successfully");
        _isInitialized = true;
      } else {
        print("❌ Model load failed");
      }

      return loaded;
    } catch (e) {
      print("❌ Model loading error: $e");
      return false;
    }
  }

  Future<bool> switchModel(String newType) async {
    if (!_isInitialized) {
      print("Service not initialized");
      return false;
    }

    if (newType == _selectedModelType) {
      print("Already using $_selectedModelType model");
      return true;
    }

    print("Switching model from $_selectedModelType to $newType");

    try {
      unloadModel();
    } catch (e) {
      print("Error unloading model: $e");
    }

    if (_currentModelFile != null && await _currentModelFile!.exists()) {
      await _currentModelFile!.delete();
    }

    _selectedModelType = newType;

    return await initModel();
  }

  void toggleListening() {
    if (!_isInitialized) {
      print("Service not initialized");
      return;
    }

    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void startListening() {
    if (!_isInitialized) {
      print("Service not initialized");
      return;
    }

    isListening = true;
    print("Started listening with $_selectedModelType model");

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      await _runInference();
    });
  }

  void stopListening() {
    isListening = false;
    _timer?.cancel();
    _timer = null;
    print("Stopped listening");
  }

  Future<void> _runInference() async {
    if (!_isInitialized) return;

    try {
      final pcmData = Int16List.fromList(List.filled(16000, 0));

      final result = await runInferenceAsync(pcmData);

      inferenceResult = result;

      print("Inference result: $result (using $_selectedModelType model)");
    } catch (e) {
      print("Inference error: $e");
    }
  }

  Future<void> dispose() async {
    stopListening();

    try {
      unloadModel();
    } catch (e) {
      print("Error unloading model: $e");
    }

    if (_currentModelFile != null && await _currentModelFile!.exists()) {
      await _currentModelFile!.delete();
      print("Temporary model file deleted");
    }

    _isInitialized = false;
    _ffiInitialized = false;
  }
}
