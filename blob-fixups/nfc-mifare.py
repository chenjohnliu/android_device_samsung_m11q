#!/usr/bin/env python3
"""Pinned M11 NFC service import fixup; leaves code and packed relocations intact."""
import argparse
import hashlib
from pathlib import Path
import struct

SERVICE_ORIGINAL = 'a47f0130eec98daaf35722f95f08e5ada8fca8e740c36a2f6d3675652435acd0'
HAL_ORIGINAL = 'a13bfb23bf57529bb076eaa2413e3fb2a2a6091996a665ce40769a5744862769'
OLD_OPEN = b'_Z16phNxpNciHal_openPFvhhEPFvtPhE'
NEW_OPEN = b'm11q_nfc_open'
SHIM = b'libshim_nfc_m11q.so'


def sha(data):
    return hashlib.sha256(data).hexdigest()


def service_fixup(data):
    # All offsets apply only to this exact ARM32 service version. The open symbol
    # is undefined and outside GNU hash coverage (index 26 < symoffset 117).
    assert data[:6] == b'\x7fELF\x01\x01', 'Expected little-endian ELF32'
    dynstr_offset = 0xb34
    open_name_offset = 0x388
    name_at = dynstr_offset + open_name_offset
    needed_value_at = 0x55ac  # Existing DT_NEEDED libdl.so string-table offset.
    old_dl_offset = 7557
    needed_name_offset = open_name_offset + len(NEW_OPEN) + 1
    replacement = NEW_OPEN + b'\0' + SHIM + b'\0'
    assert len(replacement) == len(OLD_OPEN) + 1

    def transform(original):
        result = bytearray(original)
        result[name_at:name_at + len(replacement)] = replacement
        struct.pack_into('<I', result, needed_value_at, needed_name_offset)
        return bytes(result)

    # Already fixed: reconstruct and hash-check the entire original before
    # accepting it. This also detects unrelated changes to instructions or data.
    if data[name_at:name_at + len(replacement)] == replacement:
        original = bytearray(data)
        original[name_at:name_at + len(replacement)] = OLD_OPEN + b'\0'
        struct.pack_into('<I', original, needed_value_at, old_dl_offset)
        if sha(original) != SERVICE_ORIGINAL or transform(original) != data:
            raise ValueError('Unreviewed patched NFC service version')
        return data
    if sha(data) != SERVICE_ORIGINAL:
        raise ValueError('Unreviewed NFC service version: ' + sha(data))
    assert data[name_at:name_at + len(OLD_OPEN) + 1] == OLD_OPEN + b'\0'
    assert struct.unpack_from('<II', data, needed_value_at - 4) == (1, old_dl_offset)
    assert data[dynstr_offset + old_dl_offset:].split(b'\0', 1)[0] == b'libdl.so'
    # Keep file size, segment addresses, symbol indices, .text, .rel.dyn and .relr
    # unchanged. libdl remains a required dependency through the shim itself.
    return transform(data)


def fixup(blob_path, data):
    if blob_path == 'vendor/bin/hw/android.hardware.nfc@1.1-service':
        return service_fixup(data)
    if blob_path == 'vendor/lib/nfc_nci_nxp.so':
        if sha(data) != HAL_ORIGINAL:
            raise ValueError('Unreviewed NXP HAL version: ' + sha(data))
        return data
    raise ValueError('Unexpected blob path: ' + blob_path)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('blob_path')
    parser.add_argument('file', type=Path)
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()
    original = args.file.read_bytes()
    patched = fixup(args.blob_path, original)
    if not args.dry_run and patched != original:
        args.file.write_bytes(patched)
    if not args.dry_run and args.blob_path == 'vendor/bin/hw/android.hardware.nfc@1.1-service':
        args.file.chmod(args.file.stat().st_mode | 0o111)
    print(args.blob_path + ': ' + sha(patched))
