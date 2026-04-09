import 'dart:ffi';
import 'dart:io';

Future<DynamicLibrary> loadFfiEngine() async {
  try {
    print("🚀 Loading FFI engine on Aurora OS...");

    final paths = [
      '/opt/app/aurora_flutter_app/0.1.0-1/data/lib/libffi_engine.so',
      '/usr/lib/libffi_engine.so',
      '/home/defaultuser/.local/share/aurora_flutter_app/lib/libffi_engine.so',
    ];

    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) {
        print("✅ Found library at: $path");
        final stat = await file.stat();
        print("📦 File size: ${stat.size} bytes");
        
        await Process.run('chmod', ['755', path]);
        
        print("⏳ Opening dynamic library...");
        final dylib = DynamicLibrary.open(path);
        print("✅ Successfully loaded FFI engine from $path");
        return dylib;
      }
    }

    throw Exception("libffi_engine.so not found in any expected location");
  } catch (e) {
    print("❌ Error in loadFfiEngine: $e");
    rethrow;
  }
}