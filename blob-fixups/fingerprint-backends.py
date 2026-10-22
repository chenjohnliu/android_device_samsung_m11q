#!/usr/bin/env python3
"""Version-pinned, reproducible fixups for M11's shared fingerprint HAL."""
import argparse
import hashlib
from pathlib import Path
import struct

LOADER_ORIGINAL = '8ba64ea8b026f7060fd482889bf1feda526eb55509a22f8a150bce3971e0359b'
LOADER_PATCHED = '3b0971b45b8e097454c692684a4e50f7ad6eadae68cb50a9c153966fb0e74e3b'
CDFINGER_ORIGINAL = 'eebbc65cfea4ca15e65d7e19be163f543c68aa64a63a071cef79bc0395abaa52'
CDFINGER_PATCHED = '2d71af3678cc52e8fa70c8cd51f9a240ec1054fe2007af5db0f41fcd8124e858'
OLD_ORDER = ['fingerprint.silead', 'cdfinger.fingerprint', 'fingerprint.focaltech', 'fingerprint.egis']
NEW_ORDER = ['fingerprint.silead', 'fingerprint.focaltech', 'fingerprint.egis', 'cdfinger.fingerprint']

def digest(data):
    return hashlib.sha256(data).hexdigest()

def patch_loader(data):
    current = digest(data)
    if LOADER_PATCHED and current == LOADER_PATCHED:
        return data
    if current != LOADER_ORIGINAL:
        raise ValueError('Unreviewed fingerprint service version: ' + current)
    if data[:6] != b'\x7fELF\x01\x01':
        raise ValueError('Expected little-endian ELF32')
    shoff = struct.unpack_from('<I', data, 32)[0]
    size, count, _ = struct.unpack_from('<HHH', data, 46)
    sections = [struct.unpack_from('<IIIIIIIIII', data, shoff + i * size) for i in range(count)]
    def file_offset(address):
        for section in sections:
            if section[1] != 8 and section[3] <= address < section[3] + section[5]:
                return section[4] + address - section[3]
        raise ValueError('Address is outside file-backed sections')
    def string(address):
        offset = file_offset(address)
        return data[offset:].split(b'\0', 1)[0].decode()
    offset = file_offset(0x5f18)
    pointers = struct.unpack_from('<8I', data, offset)
    if [string(pointers[i]) for i in range(0, 8, 2)] != OLD_ORDER:
        raise ValueError('Unexpected module table')
    if [string(pointers[i]) for i in range(1, 8, 2)] != ['silead', 'cdfinger', 'focaltech', 'egis']:
        raise ValueError('Unexpected module labels')
    entries = [data[offset + i * 8:offset + (i + 1) * 8] for i in range(4)]
    patched = data[:offset] + b''.join(entries[i] for i in [0, 2, 3, 1]) + data[offset + 32:]
    assert len(patched) == len(data)
    # Relocate module and label pointers together. No executable code changes.
    if LOADER_PATCHED and digest(patched) != LOADER_PATCHED:
        raise ValueError('Unexpected patched service hash')
    return patched

def patch_cdfinger(data):
    current = digest(data)
    if CDFINGER_PATCHED and current == CDFINGER_PATCHED:
        return data
    if current != CDFINGER_ORIGINAL:
        raise ValueError('Unreviewed CDFinger backend version: ' + current)
    old = b'data/system/cdfinger'
    new = b'data/vendor/cdfinger'
    assert len(old) == len(new)
    if not data.count(old):
        raise ValueError('Expected CDFinger vendor data path was not found')
    patched = data.replace(old, new)
    assert len(patched) == len(data)
    if CDFINGER_PATCHED and digest(patched) != CDFINGER_PATCHED:
        raise ValueError('Unexpected patched CDFinger hash')
    return patched

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('blob', choices=['vendor/bin/hw/android.hardware.biometrics.fingerprint@2.1-service', 'vendor/lib/hw/cdfinger.fingerprint.default.so'])
    parser.add_argument('path', type=Path)
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    original = args.path.read_bytes()
    patched = patch_loader(original) if args.blob.startswith('vendor/bin/') else patch_cdfinger(original)
    print(f'{args.blob}: {digest(original)} -> {digest(patched)}')
    if not args.dry_run and patched != original:
        args.path.write_bytes(patched)

if __name__ == '__main__':
    main()
