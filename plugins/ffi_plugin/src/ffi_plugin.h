#ifndef FFI_PLUGIN_H
#define FFI_PLUGIN_H

#include <stdint.h>

#ifdef FLUTTER_AURORA_ENABLED
#include <flutter/flutter_aurora.h>
#endif

#ifdef __cplusplus
extern "C"
{
#endif

#if defined(_WIN32)
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default")))
#endif

    FFI_PLUGIN_EXPORT int load_model(const char *model_path);

    FFI_PLUGIN_EXPORT int run_inference(const int16_t *pcm_data, int length);

    FFI_PLUGIN_EXPORT void unload_model();

#ifdef __cplusplus
}
#endif

#ifdef FLUTTER_AURORA_ENABLED
class FfiPlugin
{
public:
    static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar)
    {
        (void)registrar;
    }
};
#endif

#endif