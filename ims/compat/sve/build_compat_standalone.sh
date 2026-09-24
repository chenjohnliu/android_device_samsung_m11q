#!/bin/bash
set -euo pipefail

root=/home/quokka/android/cherish
src="$root/device/samsung/m11q/ims/compat/sve/m11q_sve_compat.cpp"
out="$root/device/samsung/m11q/ims/proprietary/app/sveservice/lib/arm/libm11q_sve_compat.so"
obj=/tmp/m11q_sve_compat.o
clang="$root/prebuilts/clang/host/linux-x86/clang-r450784d/bin/clang++"
libdir="$root/out/target/product/m11q/symbols/system/lib"
crtbegin="$root/out/soong/.intermediates/bionic/libc/crtbegin_so/android_arm_armv8-a_cortex-a53/crtbegin_so.o"
crtend="$root/out/soong/.intermediates/bionic/libc/crtend_so/android_arm_armv8-a_cortex-a53/obj/bionic/libc/arch-common/bionic/crtend_so.o"
libc="$root/out/soong/.intermediates/bionic/libc/libc/android_arm_armv8-a_cortex-a53_shared/libc.so"

cd "$root"

"$clang" -c "$src" -o "$obj" \
    -target armv7a-linux-androideabi31 -march=armv8-a -mcpu=cortex-a53 -mthumb \
    -fPIC -fno-exceptions -fno-rtti -std=gnu++17 \
    -DANDROID -D__LIBC_API__=10000 -D__LIBM_API__=10000 -D__LIBDL_API__=10000 \
    -Iframeworks/av/media/libaudioclient/include \
    -Iframeworks/av/media/libaudiofoundation/include \
    -Iframeworks/av/media/libmedia/include \
    -Iframeworks/av/media/libmediahelper/include \
    -Iframeworks/av/media/libmediametrics/include \
    -Iframeworks/av/media/liberror/include \
    -Iframeworks/av/include \
    -Iframeworks/native/libs/binder/include \
    -Iframeworks/native/libs/binder/ndk/include_cpp \
    -Iframeworks/native/libs/gui/include \
    -Isystem/core/libutils/include \
    -Isystem/core/libcutils/include \
    -Isystem/core/libsystem/include \
    -Isystem/core/libprocessgroup/include \
    -Isystem/libbase/include \
    -Isystem/logging/liblog/include \
    -Isystem/media/audio/include \
    -Iexternal/libcxx/include \
    -Iexternal/libcxxabi/include \
    -Iout/soong/.intermediates/frameworks/native/libs/binder/libbinder/android_arm_armv8-a_cortex-a53_shared/gen/aidl \
    -Iout/soong/.intermediates/frameworks/base/media/android.media.audio.common.types-V1-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/native/libs/permission/framework-permission-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/audioclient-types-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/av-types-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libshmem/shared-file-region-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/effect-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/audioflinger-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/audiopolicy-types-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/capture_state_listener-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/spatializer-aidl-cpp-source/gen/include \
    -Iout/soong/.intermediates/frameworks/av/media/libaudioclient/audiopolicy-aidl-cpp-source/gen/include \
    -isystem bionic/libc/include \
    -isystem bionic/libc/kernel/uapi/asm-arm \
    -isystem bionic/libc/kernel/uapi \
    -isystem bionic/libc/kernel/android/uapi

"$clang" -shared -nostdlib -fuse-ld=lld -target armv7a-linux-androideabi31 \
    -Wl,-soname,libm11q_sve_compat.so -Wl,--no-undefined -Wl,-z,now -Wl,-z,relro \
    "$crtbegin" "$obj" -L"$libdir" \
    -laudioclient -lutils -llog -lgui -lc++ \
    -Wl,--no-as-needed "$libdir/framework-permission-aidl-cpp.so" -Wl,--as-needed \
    "$libc" \
    "$crtend" -o "$out"
