#!/bin/bash
# Обёртка для C++-компилятора Aurora SDK

SDK_ROOT="/home/ekaterina/AuroraPlatformSDK-5.2.0.180/toolings/AuroraOS-5.2.0.180-base"

export PATH="${SDK_ROOT}/opt/cross/bin:${PATH}"
export LD_LIBRARY_PATH="${SDK_ROOT}/usr/lib:${LD_LIBRARY_PATH}"

exec "${SDK_ROOT}/opt/cross/bin/aarch64-meego-linux-gnu-g++" "$@"
