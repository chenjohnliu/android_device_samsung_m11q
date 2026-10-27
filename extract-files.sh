#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=m11q
VENDOR=samsung

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup() {
    case "${1}" in
        vendor/bin/hw/android.hardware.nfc@1.1-service|vendor/lib/nfc_nci_nxp.so)
            python3 "${MY_DIR}/blob-fixups/nfc-mifare.py" "${1}" "${2}"
            ;;
        vendor/bin/hw/android.hardware.biometrics.fingerprint@2.1-service|vendor/lib/hw/cdfinger.fingerprint.default.so)
            python3 "${MY_DIR}/blob-fixups/fingerprint-backends.py" "${1}" "${2}"
            ;;
        vendor/lib/libsec-ril.so|vendor/lib/libsec-ril-dsds.so)
            sed -i 's/ril.dds.call.slotid/vendor.calls.slotid/g' "${2}"
            ;;
        vendor/lib/hw/camera.msm8953.so)
            "${PATCHELF}" --remove-needed android.hidl.base@1.0.so "${2}"
            ;;
    esac
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
