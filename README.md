# Samsung Galaxy M11 — community ROMs

Unofficial Android 13 builds for Samsung Galaxy M11 (`SM-M115F`, `m11q`).

## Downloads

| ROM | Current release |
| --- | --- |
| CherishOS 4.12 Vanilla | [2026-10-17 release](https://github.com/chenjohnliu/android_device_samsung_m11q/releases/tag/20261017-13-Cherish) |
| crDroid 9.20 | [2026-10-18 release](https://github.com/chenjohnliu/android_device_samsung_m11q/releases/tag/20261018-13-CrDroid) |

Download the ROM ZIP from the release's **Assets** section; the automatically generated source archives are not flashable ROMs. Each release contains its installation instructions and validation scope.

## Features and validation

Both current ROMs include VoLTE, Wi-Fi Calling, SMS and microG compatibility. CherishOS Vanilla also includes the Jelly browser. Read each release for its cumulative improvements, installation steps and remaining limits.

The documented phone checks cover SMS sending and receiving, VoLTE/VoWiFi calls in each SIM slot separately, and Wi-Fi/LTE switching. CherishOS also passed microG Self-Check. Tests use one active IMS subscription, and handover timing can vary. Concurrent dual-SIM IMS is not supported; emergency calling remains unvalidated. See each release for its exact scope.

## Fixes and release history

- [Cumulative changelog](CHANGELOG.md): the development history, including FM Radio, FBE/recovery, IMS, audio routing, SMS, VoWiFi and microG changes.
- [Archived release notes](docs/release-history/README.md): the original notes and attachment metadata for retired CherishOS and crDroid releases. Historical validation statements belong to their original versions.
- [Samsung M11 IMS compatibility layer](https://github.com/chenjohnliu/Samsung-m11-ims-compat-layer): public patches, integration documentation and validation scope.

The Releases page retains the current CherishOS and crDroid downloads. Older release notes remain in the archive and their Git tags remain available; the old release ZIPs are no longer hosted there.

## Installation and data encryption

When switching ROMs, back up your data and use **TWRP → Wipe → Format Data → `yes`**. A normal Wipe alone can leave incompatible encryption state. Formatting erases internal storage.

The current releases include optional `Enable_FBE.zip` and `Disable_FBE.zip` add-ons. Never flash both. Changing between FBE and DFE requires Format Data. These add-ons have not been separately validated with the latest builds; follow the individual release notes and recovery requirements.

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
