LOCAL_PATH := $(call my-dir)

# M115F Samsung IMS core. This module is intentionally Make-based because
# Android 13's prebuilt app rules install LOCAL_PREBUILT_JNI_LIBS into the
# app-specific lib/<arch> directory.
include $(CLEAR_VARS)
LOCAL_MODULE := imsservice
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/priv-app/imsservice/imsservice.apk
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_DEX_PREOPT := false
LOCAL_OPTIONAL_USES_LIBRARIES := rcsopenapi vsimmanager EpdgManager
LOCAL_ENFORCE_USES_LIBRARIES := false
LOCAL_PREBUILT_JNI_LIBS := \
    proprietary/lib/arm/libsec-ims.so \
    proprietary/lib/arm/libaresdns.so \
    proprietary/lib/arm/libcurl2.so \
    proprietary/lib/arm/libext2_uuid.so
LOCAL_REQUIRED_MODULES := \
    imsmanager \
    imsmanager_library.xml \
    privapp-permissions-com.sec.imsservice.xml \
    imsd \
    m11q_floating_feature.xml \
    m11q_cscfeature.xml \
    m11q_carrier_feature.json \
    vsimmanager \
    vsimservice_library.xml \
    EpdgManager \
    epdgmanager_library.xml
include $(BUILD_PREBUILT)

# Exact decoded M115F CWK3 OXM/BRI carrier-feature table. The compatibility
# class intentionally uses this device-scoped copy instead of recreating the
# stock OMC mount/property manager on Android 13.
include $(CLEAR_VARS)
LOCAL_MODULE := m11q_carrier_feature.json
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := customer_carrier_feature.json
LOCAL_SRC_FILES := config/customer_carrier_feature.json
LOCAL_MODULE_PATH := $(TARGET_OUT)/etc/m11q
include $(BUILD_PREBUILT)

# Exact M115F CWK3 encoded CSC feature table. Keep this in the system root
# CSC directory; SemCscFeature reads /system/csc/cscfeature.xml.
include $(CLEAR_VARS)
LOCAL_MODULE := m11q_cscfeature.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := cscfeature.xml
LOCAL_SRC_FILES := config/cscfeature.xml
LOCAL_MODULE_PATH := $(TARGET_OUT)/csc
include $(BUILD_PREBUILT)

# Exact M115F CWK3 optional GSMA/RCS API shared library.  No partition flag is
# set intentionally: JAVA_LIBRARIES defaults to /system/framework here.
include $(CLEAR_VARS)
LOCAL_MODULE := rcsopenapi
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/framework/rcsopenapi.jar
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)

# Exact M115F CWK3 optional VSIM/Gson shared library. No partition flag is
# set intentionally: JAVA_LIBRARIES defaults to /system/framework here.
include $(CLEAR_VARS)
LOCAL_MODULE := vsimmanager
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/framework/vsimmanager.jar
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)

# Exact M115F CWK3 ePDG manager shared library. No partition flag is set:
# JAVA_LIBRARIES defaults to /system/framework here.
include $(CLEAR_VARS)
LOCAL_MODULE := EpdgManager
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/framework/EpdgManager.jar
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)

# Samsung shared Java library required by the APK manifest. Keep it in
# system_ext together with its declaration to avoid changing the base system.
include $(CLEAR_VARS)
LOCAL_MODULE := imsmanager
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/framework/imsmanager.jar
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_DEX_PREOPT := false
LOCAL_ENFORCE_USES_LIBRARIES := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := epdgmanager_library.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := epdgmanager_library.xml
LOCAL_SRC_FILES := permissions/epdgmanager_library.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := rcsopenapi_library.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := rcsopenapi_library.xml
LOCAL_SRC_FILES := permissions/rcsopenapi_library.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := vsimservice_library.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := vsimservice_library.xml
LOCAL_SRC_FILES := permissions/vsimservice_library.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := imsmanager_library.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := imsmanager_library.xml
LOCAL_SRC_FILES := permissions/imsmanager_library.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
LOCAL_SYSTEM_EXT_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_floating_feature.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := floating_feature.xml
LOCAL_SRC_FILES := config/floating_feature.xml
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := privapp-permissions-com.sec.imsservice.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := privapp-permissions-com.sec.imsservice.xml
LOCAL_SRC_FILES := permissions/privapp-permissions-com.sec.imsservice.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
LOCAL_SYSTEM_EXT_MODULE := true
include $(BUILD_PREBUILT)

# Stock M115F IPsec/PF_KEY helper. The path is moved from /system/bin to
# /system_ext/bin so its binary and private policy remain in one extension.
include $(CLEAR_VARS)
LOCAL_MODULE := imsd
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := proprietary/bin/imsd
LOCAL_MODULE_STEM := imsd
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := false
LOCAL_INIT_RC := imsd.rc
include $(BUILD_PREBUILT)

# Stage 1BH: exact M115F CWK3 system-side OEM IMS socket provider.
# Keep vendor RIL/bridge modules untouched; aliases prevent module collisions,
# while original installed SONAMEs satisfy the stock daemon's DT_NEEDED.
include $(CLEAR_VARS)
LOCAL_MODULE := m11q_ims_radio_bridge_2_0
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := vendor.samsung.hardware.radio.bridge@2.0
LOCAL_SRC_FILES := proprietary/lib/vendor.samsung.hardware.radio.bridge@2.0.so
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := true
LOCAL_SHARED_LIBRARIES := android.hardware.radio@1.0 libhidlbase liblog libutils libcutils libc++ libc libm libdl
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_ims_radio_bridge_2_1
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := vendor.samsung.hardware.radio.bridge@2.1
LOCAL_SRC_FILES := proprietary/lib/vendor.samsung.hardware.radio.bridge@2.1.so
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := true
LOCAL_SHARED_LIBRARIES := android.hardware.radio@1.0 m11q_ims_radio_bridge_2_0 libhidlbase liblog libutils libcutils libc++ libc libm libdl
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_ims_multiclientd
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_STEM := multiclientd
LOCAL_SRC_FILES := proprietary/bin/multiclientd
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := true
LOCAL_INIT_RC := multiclientd.rc
LOCAL_SHARED_LIBRARIES := libandroidicu liblog libcutils libutils android.hardware.radio@1.0 m11q_ims_radio_bridge_2_0 m11q_ims_radio_bridge_2_1 libhidlbase libhidltransport libhwbinder libc++ libc libm libdl
include $(BUILD_PREBUILT)
