# aurora_practice_project

A new Flutter project.

aurora_practice_project/
├── lib/ # Dart исходники
├── aurora/ # Конфигурация для ОС Аврора
├── plugins/ # Нативные плагины
│ └── ffi_plugin/ # FFI-плагин на C++
│ ├── lib/ # Dart API плагина
│ ├── src/ # Исходники C++
│ │ ├── ffi_plugin.cpp
│ │ └── ffi_plugin.h
│   └── CMakeLists.txt # Сборка плагина
├── assets/
│ └── models/ # TFLite модели
│ ├── model_float32.tflite
│ ├── model_float16.tflite
│ └── model_int8.tflite
├── tflite_c/ # TensorFlow Lite C
│ ├── include/ # Заголовочные файлы
│ └── lib/ # Библиотеки
├── build/ # Сборка (игнорируется git)
└── tensorflow/ # Исходники TF (игнорируется git)
