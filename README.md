Device tree for the Samsung Galaxy M11 (SM-M115F / m11q)
=================================================

Status: Booted on CherishOS 4.12 / Android 13.

## IMS status

The current `m11q-volte` branch integrates the M115F CWK3 Samsung IMS
stack through a source-only compatibility layer. With one active subscription
at a time, the tested scope includes:

- SIM1 and SIM2 IMS registration, VoLTE and SMS;
- outgoing and incoming VoLTE with bidirectional audio and normal teardown;
- outgoing Taiwan Mobile VoWiFi to 188 with audible service audio;
- incoming Taiwan Mobile VoWiFi with sustained bidirectional audio after the
  Stage 3 post-ESTABLISHED media fix;
- SIM1 removal/reinsertion recovery for the validated VoLTE/SMS baseline.

Concurrent dual-SIM operation, emergency IMS calling, ViLTE, inter-RAT
handover, other carriers and other stock builds remain unverified. Samsung's
existing behavior that may reset the Wi-Fi Calling preference after a SIM
identity change is intentionally retained.

Implementation details and proprietary-payload boundaries are documented in
[`ims/README.md`](ims/README.md). Samsung APK/JAR/ELF payloads are not intended
for publication in this repository.

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
