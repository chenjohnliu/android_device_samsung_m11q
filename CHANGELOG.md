# Changelog

This concise chronology summarizes material changes recorded in the release notes. Dates use Asia/Taipei (UTC+08:00). Each validation statement is historical and applies only to the release and setup tested at that time; it does not establish current or universal compatibility. The latest acceptance notes below describe the latest recorded tested scenario.

## 2026-07-20 — Initial CherishOS Android 13 release

- Synced the CherishOS Tiramisu branch and fixed Play Integrity behavior with GApps; device changes included double-tap-to-wake and NFC fixes.
- FM Radio, fingerprint, data encryption, VoLTE and SELinux enforcement remained known issues in that note.

## 2026-08-08 to 2026-08-15 — Device support and storage reliability

- Fixed Focaltech fingerprint behavior and matched automatic brightness to stock; the 2026-08-13 note reported FM Radio fixed and added support for both Focaltech FT9362 and Silead fingerprint sensors.
- Switched SELinux to Enforcing and introduced file-based encryption (FBE), with clean-format guidance and separate enable/disable add-ons. Documented that the then-used TWRP could not decrypt FBE.
- Kept `PRODUCT_COMPRESSED_APEX` disabled because decompressed APEX files on FBE `/data` could trigger dm-verity failure on the 4.9 kernel.
- Fixed portrait 1080p playback stutter, exFAT SD/USB OTG mounting and KernelSU root persistence. Added Miracast support, with receiver compatibility limits documented in later notes; switched from a prebuilt kernel to a kernel built from source.

## 2026-08-22 to 2026-08-24 — Performance and connectivity maintenance

- Disabled zram swap-in read-ahead, capped dexopt at half the A53 cores, changed background dexopt to `speed-profile`, and fixed OTA Survival and the built-in calendar crash.
- Fixed WPA3-Personal connection failures and Wi-Fi P2P channel reporting.

## 2026-09-07 to 2026-09-12 — IMS groundwork and slot-aware behavior

- The experimental 2026-09-07 build validated SIM1 WWAN VoLTE registration, incoming and outgoing calls, two-way audio and teardown under SELinux Enforcing.
- The 2026-09-12 release added slot-aware IMS audio routing, validated SIM2 incoming OTP SMS over IMS and an IMS attempt with operator-requested RILD2 fallback for outgoing SIM2 SMS, improved IMS recovery after SIM hot-swap or slot migration, and corrected the Samsung IMS SMS TP-Message-Reference property type.

## 2026-09-26 — CherishOS IMS integration

- Integrated the Samsung `M115FXXS5CWK3` IMS stack with stock-derived native dependencies, supporting one active subscription in either SIM slot, tested separately.
- Validated outgoing and incoming VoLTE calls with bidirectional audio and normal teardown, plus functional SMS send/receive on SIM1 and SIM2; outgoing SMS could use modem fallback. SIM1 removal and reinsertion recovery was validated.
- Validated VoWiFi outgoing and incoming calls with normal teardown on the stated Taiwan Mobile setup. Inter-RAT handover remained unverified in this release.

## 2026-10-11 — crDroid maintenance release

- Carried the IMS stack to crDroid Android 13, fixed stale VoWiFi status and improved SIM phone-number display through Android subscription APIs.
- Recorded VoLTE/VoWiFi calls and handovers on SIM1 and SIM2 separately with one active SIM; SMS send/receive and the IMS SMS bridge were supported in the stated test scope.

## 2026-10-13 — Latest CherishOS release and acceptance

- Updated the CherishOS IMS integration and its framework, MMS-service and Telecom companion changes; restored restricted microG signature spoofing with modern `SigningInfo` support. microG Self-Check passed on this build.
- Retained the stock 128-second SIP Timer F and Android 13 incoming-call and handover audio hooks; preserved Samsung's modem-led legacy IWLAN handover and Android's deferred Wi-Fi shutdown.
- Latest acceptance records SMS sending and receiving as **PASS**, including the Samsung-to-Android IMS SMS bridge. VoLTE/VoWiFi call validation covered **both SIM slots, tested separately with one active SIM**; concurrent dual-SIM/DSDS remains unsupported.
- Wi-Fi/LTE and VoWiFi/VoLTE handovers passed in the recorded single-active-SIM scenarios. On weak-signal departure from Wi-Fi, the ongoing call did not drop; after Wi-Fi coverage returned, the tested call returned to VoWiFi in approximately two minutes. Timing can vary with network and signal conditions.
- Brief audio pauses during handover may occur. Emergency calling remains unvalidated; carrier provisioning and ePDG reachability affect Wi-Fi Calling.

## Original notes

The [release-note archive](docs/release-history/README.md) preserves each retired release's complete original text and attachment metadata, including the detailed installation instructions and historical limitations omitted from this summary.
