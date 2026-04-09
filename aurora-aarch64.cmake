set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER/home/e_markina/AuroraPlatformSDK-5.1.6.110/toolings/AuroraOS-5.1.6.110-base/opt/cross/bin/aarch64-meego-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER/home/e_markina/AuroraPlatformSDK-5.1.6.110/toolings/AuroraOS-5.1.6.110-base/opt/cross/bin/aarch64-meego-linux-gnu-g++)

set(CMAKE_SYSROOT/home/e_markina/AuroraPlatformSDK-5.1.6.110/toolings/AuroraOS-5.1.6.110-base/opt/cross/aarch64-meego-linux-gnu/sys-root)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_EXE_LINKER_FLAGS "-Wl,--sysroot=${CMAKE_SYSROOT}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--sysroot=${CMAKE_SYSROOT}" CACHE STRING "" FORCE)
