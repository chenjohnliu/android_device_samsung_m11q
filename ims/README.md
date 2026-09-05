# M115F IMS compatibility layer — Stage 1

This directory contains the device-side integration used by the validated
Samsung Galaxy M11 SIM1 WWAN VoLTE bring-up on Android 13.

## What it enables

- `com.sec.imsservice` as a privileged, platform-signed, 32-bit system_ext app.
- Exact M115F `imsmanager.jar` and its shared-library declaration.
- Four app-private ARM32 native libraries through `LOCAL_PREBUILT_JNI_LIBS`.
- Exact M115F `imsd` binary with the stock user/group/capability contract.
- Dedicated system_ext-private SELinux domains and exact service labels.
- Exact M115F dual `multiclientd` providers and Samsung radio bridge clients.
- A patched Samsung IMS APK containing the Android 13 `ImsService`/MmTel
  compatibility facade used by the Stage 1 runtime.
- The carrier and framework compatibility configuration required by that APK.

Validated scope is outgoing SIM1 WWAN VoLTE registration, call establishment,
clear two-way speech and teardown under Enforcing. Incoming calls, SIM2/DSDS,
VoWiFi and emergency calling are not claimed here.

## Integration

1. Restore or obtain a clean `device/samsung/m11q` checkout.
2. Copy this `ims` directory to `device/samsung/m11q/ims`.
3. Apply the two fragments under `integration/` to `device.mk` and
   `BoardConfig.mk`.
4. Run `verify_payload.ps1` before any build.
5. Review SELinux against the exact branch policy. Never disable enforcing or
   import generated `audit2allow` output.

The modules use system_ext intentionally so package, helper and private policy
remain in an OEM platform extension. Consequently the shared-library XML points
to `/system_ext/framework/imsmanager.jar`, and init launches
`/system_ext/bin/imsd`. These are controlled path relocations from stock; any
Samsung hard-coded `/system/...` lookup is a runtime STOP condition.

## Proprietary payload

Files under `proprietary/` originate from the user's own M115F stock firmware.
They are required to reproduce the local build but are not suitable for blind
redistribution in a public source repository. A public release should provide
an extraction workflow and verified hashes instead of committing Samsung APK,
JAR, ELF or executable payloads.

No Android ROM build is performed by this directory.
