# M11 NFC reader initialization

The retained PN553 HAL reads `MIFARE_READER_ENABLE` in MinOpen, but the ordinary
open path can leave `bEnableMfcReader` at zero despite an enabled configuration.
The device service's pinned open import is redirected to `libshim_nfc_m11q`.
The wrapper prepares the HAL config, initializes only the exported reader flag
from that existing setting, and forwards the original open callbacks and status.

`blob-fixups/nfc-mifare.py` validates the exact service/HAL versions and rewrites
only the service import and one dependency string. The service's instructions,
relocations, segment layout and version requirements remain unchanged. The HAL,
firmware and NFC configuration files are not patched. Unsupported blob versions
must be reviewed explicitly rather than accepted automatically.

The shim is vendor 32-bit and depends on libdl/liblog. The service reaches libdl
through the shim dependency. Its imported open symbol is unversioned and outside
the service's GNU-hash coverage. Do not apply the pinned string-table offsets to
another service version.

This does not change legacy processing, technology labels, reconnect handling or
the selected NFC HAL instance/version. A disabled or missing reader setting stays
disabled. Missing initialization symbols are logged and stock open still runs.

An actual-device RAM-only A/B/A test on crDroid showed NfcA -> MifareClassic ->
NfcA for the same card. A second enabled round exposed MifareClassic on three
user scans. Connection retries/delay remain under investigation; protected-sector
I/O and this source-built shim have not yet been validated on the device.

After the maintainer builds and flashes, look for `m11q_nfc` with
`config_found=1 enabled=1` after NFC open. With the case removed, compare the same
card across NFC off/on and reboot. Test ordinary tags and other NFC functions as
well; do not interpret technology enumeration alone as complete Classic I/O.
