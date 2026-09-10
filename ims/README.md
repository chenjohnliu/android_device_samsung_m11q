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

## Validated Stage 1 scope

Validated from 2026-09-07 through 2026-09-10 with SIM1 WWAN under SELinux Enforcing:

- IMS registration and Android MmTel Voice capability;
- outgoing VoLTE establishment, clear bidirectional speech and teardown;
- incoming SIP delivery and Samsung incoming-session creation;
- Android Telephony `RINGING` and Telecom successful-incoming-call handling;
- Dialer ringing, answer, clear bidirectional speech and teardown;
- stable `com.sec.imsservice` process and IMS registration across the incoming
  call; the VoLTE indicator no longer disappears.
- outgoing SMS delivery through the validated IMS-to-SGs/CS fallback;
- physical SIM1 removal/reinsertion followed by automatic VoLTE recovery;
- post-hot-swap outgoing and incoming VoLTE, bidirectional speech and teardown;
- post-hot-swap SMS send and receive.

The incoming golden trace reaches this sequence:

```text
onNewIncomingCall
  -> onImsIncomingCallEvent
  -> ImsPhoneCallTracker newState=RINGING
  -> Telecom successful incoming call
  -> ImsPhoneCallTracker onCallStarted
  -> active call
  -> normal disconnect
```

The previously observed `ISecImsMmTelEventListener` linkage crash and the
subsequent incoming Binder deadlock are absent from the successful capture.
The IMS process PID is unchanged before and after the call.

Golden runtime capture names:

- `volte_capture_20260907_092745_friend_call_me` (incoming/MT);
- `volte_capture_20260907_093116_I_call_friend` (outgoing/MO).

On 2026-09-10, the runtime-validated candidate used the Stage 1BQ3 IMS bridge
with the carrier-neutral BQ6 Telephony fallback. A clean-flash control passed a
call to 188 before and after SIM1 removal/reinsertion. The VoLTE indicator
returned automatically, an external incoming call rang and completed with
clear two-way speech and normal teardown, and SMS send/receive passed. Earlier
cold-boot call failures persisted after source rollback but disappeared after
formatting `/data`; they are evidence of persistent-state contamination, not a
BQ code regression. The exact contaminating IMS/Telephony data item remains
unidentified.

This claim remains deliberately SIM1-only. SIM2 currently does not expose a
VoLTE/MMTEL support flag, and SIM2/DSDS behavior has not been validated. Pure
IMS-SMS delivery and the transport used by the received SMS are not claimed.
VoWiFi, emergency calling, video calling/ViLTE, inter-RAT handover, alternate
audio devices, other stock builds/models/carriers, and extended regression
testing are also not claimed.

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
