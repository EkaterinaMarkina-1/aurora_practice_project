cmake_minimum_required(VERSION 3.10)
project(ffi_plugin_library VERSION 0.0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(ffi_plugin SHARED
  ffi_plugin.cpp
)

# TensorFlow Lite
set(TFLITE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../tflite_c")

target_include_directories(ffi_plugin
  PUBLIC
    ${TFLITE_DIR}/include
)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|armv8")
    set(TFLITE_LIB "${TFLITE_DIR}/lib/aarch64/libtensorflowlite_c.so")
    message(STATUS "Building for ARM64/aarch64, using: ${TFLITE_LIB}")
else()
    set(TFLITE_LIB "${TFLITE_DIR}/lib/libtensorflowlite_c.so")
    message(STATUS "Building for x86_64, using: ${TFLITE_LIB}")
endif()

if(NOT EXISTS ${TFLITE_LIB})
    message(FATAL_ERROR "TensorFlow Lite library not found at: ${TFLITE_LIB}")
endif()

target_link_libraries(ffi_plugin
  ${TFLITE_DIR}/lib/libtensorflowlite_c.so
)

set_target_properties(ffi_plugin PROPERTIES
  OUTPUT_NAME "ffi_engine"
)

target_compile_definitions(ffi_plugin PUBLIC DART_SHARED_LIB)
