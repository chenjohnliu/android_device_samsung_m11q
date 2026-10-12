# Samsung Galaxy M11 — community ROMs

Unofficial Android 13 builds for Samsung Galaxy M11 (`SM-M115F`, `m11q`).

## Downloads

| ROM | Current release |
| --- | --- |
| CherishOS 4.12 Vanilla | [2026-10-12 release](https://github.com/chenjohnliu/android_device_samsung_m11q/releases/tag/20261012-13-Cherish) |
| crDroid 9.20 | [2026-10-10 release tag](https://github.com/chenjohnliu/android_device_samsung_m11q/releases/tag/20261010-13-CrDroid) |

Download the ROM ZIP from the release's **Assets** section; the automatically generated source archives are not flashable ROMs. Each release contains its installation instructions and validation scope.

## Features and validation

The current CherishOS release includes Samsung stock-derived IMS compatibility, VoLTE/VoWiFi, the Android IMS SMS bridge, restricted microG signature spoofing, the Jelly browser, and optional FBE enable/disable packages.

The maintainer validated SMS sending and receiving, microG Self-Check, VoLTE/VoWiFi calls with one active SIM in each slot separately, and Wi-Fi/LTE handovers. Weak Wi-Fi signal handover preserved the call; returning to VoWiFi took approximately two minutes in the tested scenario. Concurrent dual-SIM IMS is not supported; end-to-end emergency calling remains unvalidated. See the release notes for the full scope and limitations.

## Fixes and release history

- [Cumulative changelog](CHANGELOG.md): the development history, including FM Radio, FBE/recovery, IMS, audio routing, SMS, VoWiFi and microG changes.
- [Archived release notes](docs/release-history/README.md): the complete original notes and attachment metadata for ten retired CherishOS releases. Historical validation statements belong to their original versions.
- [Samsung M11 IMS compatibility layer](https://github.com/chenjohnliu/Samsung-m11-ims-compat-layer): public patches, integration documentation and validation scope.

The Releases page retains the current CherishOS and crDroid downloads. Older release notes remain in the archive and their Git tags remain available; the old release ZIPs are no longer hosted there.

## Installation and data encryption

When switching ROMs, back up your data and use **TWRP → Wipe → Format Data → `yes`**. A normal Wipe alone can leave incompatible encryption state. Formatting erases internal storage.

CherishOS's current release includes `Enable_FBE.zip` and `Disable_FBE.zip`. Use only the package matching your intended encryption setting, never both. Changing between FBE and DFE requires Format Data. Follow the release-specific recovery instructions; do not assume the CherishOS add-ons also work with crDroid.

## IMS implementation

The `m11q-volte` branch integrates the M115F CWK3 Samsung IMS stack through a source-only compatibility layer. Implementation details and proprietary-payload boundaries are documented in [`ims/README.md`](ims/README.md). Samsung APK/JAR/ELF payloads are not intended for publication in this repository.

## Device Specifications

Basic | Spec Sheet
---: | :---
SoC | Qualcomm MSM8953 Snapdragon 450
CPU | Octa core (1.8 GHz)
GPU | Adreno 506
Memory | 2GB / 4 GB RAM
Shipped Android Version | 10.0
Storage | 32GB / 64GB
MicroSD | Up to 512 GB (dedicated slot)
Battery | Non-removable Li-Ion 5000 mAh battery
Dimensions | 161.4 x 76.3 x 9 mm (6.35 x 3.00 x 0.35 in)
Display | 720 x 1560 pixels, 19.5:9 ratio (~268 ppi density)
Rear Camera (Main) | 13 MP, f/1.8, 27mm (wide), 1/3.1", 1.12µm, PDAF
Rear Camera (Ultra-wide) | 5 MP, f/2.2, 14mm (ultra-wide), 115°
Rear Camera (Depth) | 2 MP, f/2.4 (depth)
Front Camera | 8 MP, f/2.0, 1/4.0", 1.12µm

## Device Picture

![Samsung Galaxy M11](https://fdn2.gsmarena.com/vv/pics/samsung/samsung-galaxy-m11-sm-m115-1.jpg)
