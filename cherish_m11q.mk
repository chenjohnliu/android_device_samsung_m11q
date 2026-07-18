# Copyright (C) 2025 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Inherit from those products, Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from m11q device
$(call inherit-product, device/samsung/m11q/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/cherish/config/common_full_phone.mk)

PRODUCT_CHARACTERISTICS := default

PRODUCT_DEVICE := m11q
PRODUCT_NAME := cherish_m11q
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-M115F
PRODUCT_MANUFACTURER := samsung

PRODUCT_SYSTEM_NAME := m11qnsxx
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.cherish.maintainer="Quokka"

PRODUCT_GMS_CLIENTID_BASE := android-samsung-ss

TARGET_VENDOR := samsung
TARGET_VENDOR_PRODUCT_NAME := m11q

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="m11qnsxx-user 11 RP1A.200720.012 M115FXXU3BVD1 release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := "samsung/m11qnsxx/m11q:11/RP1A.200720.012/M115FXXU3BVD1:user/release-keys"
