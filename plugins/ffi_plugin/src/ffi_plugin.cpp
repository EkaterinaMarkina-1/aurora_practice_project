

#include "ffi_plugin.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "tensorflow/lite/c/c_api.h"

static TfLiteModel *model = nullptr;
static TfLiteInterpreter *interpreter = nullptr;
static TfLiteInterpreterOptions *options = nullptr;

FFI_PLUGIN_EXPORT int load_model(const char *model_path)
{
  if (!model_path)
    return 0;

  if (interpreter)
  {
    TfLiteInterpreterDelete(interpreter);
    interpreter = nullptr;
  }
  if (options)
  {
    TfLiteInterpreterOptionsDelete(options);
    options = nullptr;
  }
  if (model)
  {
    TfLiteModelDelete(model);
    model = nullptr;
  }

  model = TfLiteModelCreateFromFile(model_path);
  if (!model)
  {
    printf("Failed to load model: %s\n", model_path);
    return 0;
  }

  options = TfLiteInterpreterOptionsCreate();
  TfLiteInterpreterOptionsSetNumThreads(options, 2);

  interpreter = TfLiteInterpreterCreate(model, options);
  if (!interpreter)
  {
    printf("Failed to create interpreter\n");
    return 0;
  }

  if (TfLiteInterpreterAllocateTensors(interpreter) != kTfLiteOk)
  {
    printf("Failed to allocate tensors\n");
    return 0;
  }

  printf("Model loaded successfully: %s\n", model_path);
  return 1;
}

FFI_PLUGIN_EXPORT int run_inference(const int16_t *pcm_data, int length)
{
  if (!interpreter || !pcm_data || length <= 0)
    return -1;

  TfLiteTensor *input_tensor = TfLiteInterpreterGetInputTensor(interpreter, 0);
  if (!input_tensor)
    return -1;

  size_t input_bytes = TfLiteTensorByteSize(input_tensor);
  if (length * sizeof(int16_t) > input_bytes)
  {
    printf("Input audio too large for model\n");
    return -1;
  }

  if (TfLiteTensorCopyFromBuffer(input_tensor, pcm_data, length * sizeof(int16_t)) != kTfLiteOk)
  {
    printf("Failed to copy input tensor\n");
    return -1;
  }

  if (TfLiteInterpreterInvoke(interpreter) != kTfLiteOk)
  {
    printf("Inference failed\n");
    return -1;
  }

  const TfLiteTensor *output_tensor = TfLiteInterpreterGetOutputTensor(interpreter, 0);
  if (!output_tensor)
    return -1;

  int output_size = TfLiteTensorByteSize(output_tensor) / sizeof(float);
  const float *output_data = (const float *)TfLiteTensorData(output_tensor);

  int max_index = 0;
  float max_value = output_data[0];

  for (int i = 1; i < output_size; i++)
  {
    if (output_data[i] > max_value)
    {
      max_value = output_data[i];
      max_index = i;
    }
  }

  return max_index;
}

FFI_PLUGIN_EXPORT void unload_model()
{
  if (interpreter)
  {
    TfLiteInterpreterDelete(interpreter);
    interpreter = nullptr;
  }
  if (options)
  {
    TfLiteInterpreterOptionsDelete(options);
    options = nullptr;
  }
  if (model)
  {
    TfLiteModelDelete(model);
    model = nullptr;
  }
}
