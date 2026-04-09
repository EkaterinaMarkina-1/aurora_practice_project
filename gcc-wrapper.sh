#!/bin/bash
# Обёртка для C-компилятора Aurora SDK

SDK_ROOT="/home/ekaterina/AuroraPlatformSDK-5.2.0.180/toolings/AuroraOS-5.2.0.180-base"

# Добавляем bin-папку SDK в PATH (чтобы найти правильный as, ld, ar...)
export PATH="${SDK_ROOT}/opt/cross/bin:${PATH}"

# Добавляем lib-папку в LD_LIBRARY_PATH (чтобы найти libmpfr.so.4)
export LD_LIBRARY_PATH="${SDK_ROOT}/usr/lib:${LD_LIBRARY_PATH}"

# Запускаем настоящий компилятор
exec "${SDK_ROOT}/opt/cross/bin/aarch64-meego-linux-gnu-gcc" "$@"
