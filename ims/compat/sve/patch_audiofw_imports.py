#!/usr/bin/env python3
"""Make CWK3 audio entry points with Android 12 inline object access compat imports.

The input is the exact SM-M115F CWK3 libAudioFWInterface.so.  Its internal
AUDIOFW_WAVEOUTOPEN call already uses a JUMP_SLOT relocation, but the target
symbol is defined by the same DSO, so a separately dlopened RTLD_LOCAL shim
cannot preempt it.  This patch changes the WaveOut and ABI-sensitive WaveIn
entry points to undefined dynamic symbols and replaces the direct
framework-permission dependency with libm11q_sve_compat.  The compat DSO keeps
framework-permission-aidl-cpp.so in the dependency closure.
"""

import hashlib
import pathlib
import struct
import sys

EXPECTED_SHA256 = "c9242fe987c93b2363875e1dfbb9a2450676e3d68cd56b78b15a53a6604e52c4"
DYNAMIC_STRING_OLD = b"framework-permission-aidl-cpp.so\0"
DYNAMIC_STRING_NEW = b"libm11q_sve_compat.so\0"
DYN_SYM_OFFSET = 0x1AC
DYN_SYM_SIZE = 0x10
WAVE_OUT_OPEN_INDEX = 26
WAVE_OUT_CLOSE_INDEX = 41
WAVE_IN_OPEN_INDEX = 34
WAVE_IN_CLOSE_INDEX = 28
WAVE_IN_CLEAR_INDEX = 44
REMAIN_CHUNK_INDEX = 37


def undefine_symbol(image: bytearray, index: int) -> None:
    offset = DYN_SYM_OFFSET + index * DYN_SYM_SIZE
    # Preserve st_name, st_info and st_other. Clear st_value, st_size and
    # st_shndx so the existing relocation resolves from the compat dependency.
    image[offset + 4:offset + 12] = b"\0" * 8
    image[offset + 14:offset + 16] = b"\0" * 2


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} INPUT OUTPUT", file=sys.stderr)
        return 2

    source = pathlib.Path(sys.argv[1])
    destination = pathlib.Path(sys.argv[2])
    original = source.read_bytes()
    digest = hashlib.sha256(original).hexdigest()
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"unexpected input SHA-256: {digest}")
    if original[:6] != b"\x7fELF\x01\x01":
        raise SystemExit("input is not a little-endian ELF32 image")
    if struct.unpack_from("<H", original, 18)[0] != 40:
        raise SystemExit("input is not an ARM ELF")
    if original.count(DYNAMIC_STRING_OLD) != 1:
        raise SystemExit("expected dependency string not found exactly once")

    image = bytearray(original)
    replacement = DYNAMIC_STRING_NEW.ljust(len(DYNAMIC_STRING_OLD), b"\0")
    image = bytearray(bytes(image).replace(DYNAMIC_STRING_OLD, replacement, 1))
    undefine_symbol(image, WAVE_OUT_OPEN_INDEX)
    undefine_symbol(image, WAVE_OUT_CLOSE_INDEX)
    undefine_symbol(image, WAVE_IN_OPEN_INDEX)
    undefine_symbol(image, WAVE_IN_CLOSE_INDEX)
    undefine_symbol(image, WAVE_IN_CLEAR_INDEX)
    undefine_symbol(image, REMAIN_CHUNK_INDEX)
    destination.write_bytes(image)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
