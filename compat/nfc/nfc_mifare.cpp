/*
 * Copyright (C) 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "m11q_nfc"
#include <dlfcn.h>
#include <stdint.h>

#include <log/log.h>

namespace {
using EventCallback = void (*)(uint8_t, uint8_t);
using DataCallback = void (*)(uint16_t, uint8_t*);
using Open = uint16_t (*)(EventCallback, DataCallback);
using PrepareRfConfig = void (*)();
using ResetConfig = void (*)();
using GetNumber = int (*)(const char*, void*, unsigned long);

constexpr char kStockOpen[] = "_Z16phNxpNciHal_openPFvhhEPFvtPhE";
constexpr uint16_t kNfcStatusFailed = 0x00ff;
static_assert(sizeof(bool) == 1, "NXP HAL exports a one-byte reader flag");

void initializeMifareReader() {
    // Use the HAL's RF-path selection and config parser before reading its config.
    const auto prepare = reinterpret_cast<PrepareRfConfig>(
            dlsym(RTLD_DEFAULT, "_Z25phNxpNciHal_GetRfConfPathv"));
    const auto reset = reinterpret_cast<ResetConfig>(
            dlsym(RTLD_DEFAULT, "resetNxpConfig"));
    const auto number = reinterpret_cast<GetNumber>(
            dlsym(RTLD_DEFAULT, "GetNxpNumValue"));
    auto* const reader = static_cast<bool*>(
            dlsym(RTLD_DEFAULT, "bEnableMfcReader"));

    if (prepare == nullptr || reset == nullptr || number == nullptr || reader == nullptr) {
        ALOGE("MIFARE reader initialization symbols unavailable; using stock open behavior");
        return;
    }

    prepare();
    reset();

    uint32_t value = 0;
    *reader = false;
    const int configFound = number("MIFARE_READER_ENABLE", &value, sizeof(value));
    if (configFound != 0) {
        *reader = value != 0;
    }
    ALOGI("MIFARE reader initialization: config_found=%d enabled=%d",
          configFound != 0, *reader);
}
}  // namespace

// The pinned service's undefined open import is redirected here. The stock HAL
// still performs hardware initialization and receives the original callbacks.
extern "C" __attribute__((visibility("default"))) uint16_t m11q_nfc_open(
        EventCallback eventCallback, DataCallback dataCallback) {
    const auto stockOpen = reinterpret_cast<Open>(dlsym(RTLD_DEFAULT, kStockOpen));
    if (stockOpen == nullptr) {
        ALOGE("Stock NFC open symbol unavailable");
        return kNfcStatusFailed;
    }
    initializeMifareReader();
    return stockOpen(eventCallback, dataCallback);
}
