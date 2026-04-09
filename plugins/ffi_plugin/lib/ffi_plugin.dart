import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'ffi_plugin_bindings_generated.dart';
import 'ffi_loader.dart';

late final FfiPluginBindings _bindings;

Future<void> initFfiPlugin() async {
  final dylib = await loadFfiEngine();
  _bindings = FfiPluginBindings(dylib);
}

Future<bool> loadModel(String modelPath) async {
  final pathPtr = modelPath.toNativeUtf8();
  final result = _bindings.load_model(pathPtr.cast());
  malloc.free(pathPtr);
  return result != 0;
}

void unloadModel() {
  try {
    _bindings.unload_model();
    print("✅ Model unloaded successfully");
  } catch (e) {
    print("❌ Error unloading model: $e");
  }
}

int runInference(Int16List pcmData) {
  final ptr = malloc<Int16>(pcmData.length);
  ptr.asTypedList(pcmData.length).setAll(0, pcmData);

  final result = _bindings.run_inference(ptr, pcmData.length);

  malloc.free(ptr);
  return result;
}

Future<int> runInferenceAsync(Int16List pcmData) async {
  return await Future(() => runInference(pcmData));
}

class FfiPlugin {
  //Регистрация плагина для Aurora OS
  static void registerWith() {
    print("FfiPlugin registered on Aurora OS");
  }
}
