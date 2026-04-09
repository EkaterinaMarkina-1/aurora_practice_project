cmake_minimum_required(VERSION 3.10)
project(ffi_plugin LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")

add_library(ffi_plugin SHARED
  ${SRC_DIR}/ffi_plugin.cpp
)

set(TFLITE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../tflite_c")

target_include_directories(ffi_plugin PRIVATE
  ${TFLITE_DIR}/include
  ${SRC_DIR}
)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|armv8")
    set(TFLITE_LIB "${TFLITE_DIR}/lib/aarch64/libtensorflowlite_c.so")
    message(STATUS "Building for ARM64, using: ${TFLITE_LIB}")
else()
    set(TFLITE_LIB "${TFLITE_DIR}/lib/libtensorflowlite_c.so")
    message(STATUS "Building for x86_64, using: ${TFLITE_LIB}")
endif()

target_link_libraries(ffi_plugin
    ${TFLITE_LIB}
)

set_target_properties(ffi_plugin PROPERTIES
  OUTPUT_NAME "ffi_engine"
  PREFIX "lib"
  SUFFIX ".so"
)

target_compile_definitions(ffi_plugin PUBLIC DART_SHARED_LIB)

install(FILES ${SRC_DIR}/ffi_plugin.h
  DESTINATION include/ffi_plugin
)

install(TARGETS ffi_plugin
  LIBRARY DESTINATION lib
)
