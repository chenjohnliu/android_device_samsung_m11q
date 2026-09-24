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

# Compatibility registration for Samsung's required svemanager Java shared
# library. The M115F APKs carry their matching com.sec.sve Binder classes;
# this small library supplies the PackageManager-visible framework entry that
# AOSP does not ship.
include $(CLEAR_VARS)
LOCAL_MODULE := svemanager
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := src/svemanager/com/sec/sve/compat/SveManagerLibrary.java
LOCAL_SDK_VERSION := system_current
LOCAL_DEX_PREOPT := false
include $(BUILD_JAVA_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := svemanager_library.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := svemanager_library.xml
LOCAL_SRC_FILES := permissions/svemanager_library.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
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

# Exact M115F CWK3 Wi-Fi Calling activity/provider package. EpdgService checks
# both this package and LaunchUnifiedActivity before it enables ePDG, so this
# is a functional dependency rather than an optional settings front end.
# Keep the stock /system/app placement; platform signing supplies the Android
# signature permissions requested by the original Samsung package.
include $(CLEAR_VARS)
LOCAL_MODULE := UnifiedWFC
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/app/UnifiedWFC/UnifiedWFC.apk
LOCAL_CERTIFICATE := platform
LOCAL_DEX_PREOPT := false
LOCAL_OPTIONAL_USES_LIBRARIES := imsmanager
LOCAL_ENFORCE_USES_LIBRARIES := false
LOCAL_REQUIRED_MODULES := imsmanager
include $(BUILD_PREBUILT)

# Stock M115F application-processor media engine used for IWLAN audio. VoLTE
# uses the modem-side CpAudioEngine, while VoWiFi selects this service when it
# creates the audio session. Keep all Samsung-only ELF dependencies and the
# narrow Android 12-to-13 symbol/layout shim private to the app's 32-bit native
# library directory. The shim also interposes only the WaveOut open/close path,
# because CWK3's inline sp<AudioTrack> and field offsets do not match Android 13.
# FrameCapture is an audio-safe, video-disabled ABI stub.
include $(CLEAR_VARS)
LOCAL_MODULE := sveservice
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/app/sveservice/sveservice.apk
LOCAL_CERTIFICATE := platform
LOCAL_MULTILIB := 32
LOCAL_DEX_PREOPT := false
LOCAL_OPTIONAL_USES_LIBRARIES := svemanager
LOCAL_ENFORCE_USES_LIBRARIES := false
LOCAL_PREBUILT_JNI_LIBS := \
    proprietary/app/sveservice/lib/arm/libAudioFWInterface.so \
    proprietary/app/sveservice/lib/arm/libAudioTranscoder.so \
    proprietary/app/sveservice/lib/arm/libPSI.so \
    proprietary/app/sveservice/lib/arm/libRecorder.so \
    proprietary/app/sveservice/lib/arm/libSRTP.so \
    proprietary/app/sveservice/lib/arm/libSTE.so \
    proprietary/app/sveservice/lib/arm/libSamsungAPVoiceEngine.so \
    proprietary/app/sveservice/lib/arm/lib_android_FrameCapture.so \
    proprietary/app/sveservice/lib/arm/libamrnb_float.so \
    proprietary/app/sveservice/lib/arm/libamrwb_float.so \
    proprietary/app/sveservice/lib/arm/libevs_float.so \
    proprietary/app/sveservice/lib/arm/libfloatingfeature.so \
    proprietary/app/sveservice/lib/arm/libm11q_sve_compat.so \
    proprietary/app/sveservice/lib/arm/libmediarelayengine.so \
    proprietary/app/sveservice/lib/arm/libnativecfms.so \
    proprietary/app/sveservice/lib/arm/libresampler_ims.so \
    proprietary/app/sveservice/lib/arm/librtp.so \
    proprietary/app/sveservice/lib/arm/librtppayload.so \
    proprietary/app/sveservice/lib/arm/libsamsung_videoengine_9_0.so \
    proprietary/app/sveservice/lib/arm/libsavscmn.so \
    proprietary/app/sveservice/lib/arm/libsecnativefeature.so \
    proprietary/app/sveservice/lib/arm/libsvejni.so \
    proprietary/app/sveservice/lib/arm/libsveservice.so \
    proprietary/app/sveservice/lib/arm/libvad.so
LOCAL_REQUIRED_MODULES := \
    svemanager \
    svemanager_library.xml
include $(BUILD_PREBUILT)

# Exact CWK3 Samsung AP-assisted IWLAN service. Platform signing is required
# because the manifest uses android.uid.system.
include $(CLEAR_VARS)
LOCAL_MODULE := EpdgService
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := proprietary/priv-app/EpdgService/EpdgService.apk
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_DEX_PREOPT := false
LOCAL_OPTIONAL_USES_LIBRARIES := EpdgManager imsmanager
LOCAL_ENFORCE_USES_LIBRARIES := false
LOCAL_REQUIRED_MODULES := \
    EpdgManager \
    imsmanager \
    m11q_epdg_apns_conf.xml \
    m11q_mapconprovider.xml \
    privapp-permissions-com.sec.epdg.xml \
    m11q_eris \
    m11q_eris_conf \
    m11q_eris_strongswan \
    m11q_eris_charon \
    m11q_eris_simaka \
    m11q_eris_secril_client
LOCAL_REQUIRED_MODULES += UnifiedWFC
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_epdg_apns_conf.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := epdg_apns_conf.xml
LOCAL_SRC_FILES := proprietary/etc/epdg_apns_conf.xml
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_mapconprovider.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := mapconprovider.xml
LOCAL_SRC_FILES := proprietary/etc/mapconprovider.xml
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := privapp-permissions-com.sec.epdg.xml
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := privapp-permissions-com.sec.epdg.xml
LOCAL_SRC_FILES := permissions/privapp-permissions-com.sec.epdg.xml
LOCAL_MODULE_RELATIVE_PATH := permissions
LOCAL_SYSTEM_EXT_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_eris_conf
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_STEM := eris.conf
LOCAL_SRC_FILES := proprietary/etc/eris.conf
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_eris
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_STEM := eris
LOCAL_SRC_FILES := proprietary/bin/eris
# multiclientd identifies the ERIS OEM client from /proc/<pid>/cmdline and
# accepts only the stock executable name /system/bin/eris.  Installing this
# binary in system_ext changes argv[0] and makes SIM AKA fail before the OEM
# authentication request reaches RIL.
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := false
LOCAL_INIT_RC := eris.rc
LOCAL_REQUIRED_MODULES := \
    m11q_eris_crypto_compat \
    m11q_eris_ssl_compat
include $(BUILD_PREBUILT)

# eris was built against Samsung's Android 12 OpenSSL ABI, including the
# legacy LHASH entry points removed from Android 13's BoringSSL. Install a
# private, renamed VNDK 31 pair so no platform or unrelated process resolves
# against the compatibility libraries.
include $(CLEAR_VARS)
LOCAL_MODULE := m11q_eris_crypto_compat
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := liberc
LOCAL_SRC_FILES := proprietary/lib/arm/liberc.so
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := true
LOCAL_SHARED_LIBRARIES := libc libm libdl
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m11q_eris_ssl_compat
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := libers
LOCAL_SRC_FILES := proprietary/lib/arm/libers.so
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := true
LOCAL_SHARED_LIBRARIES := m11q_eris_crypto_compat libc libm libdl
include $(BUILD_PREBUILT)

define m11q-eris-lib
include $$(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_OWNER := samsung
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_STEM := $(2)
LOCAL_SRC_FILES := proprietary/lib/arm/$(2).so
LOCAL_SYSTEM_EXT_MODULE := true
LOCAL_MULTILIB := 32
LOCAL_STRIP_MODULE := false
LOCAL_CHECK_ELF_FILES := false
include $$(BUILD_PREBUILT)
endef

$(eval $(call m11q-eris-lib,m11q_eris_strongswan,liberis_strongswan))
$(eval $(call m11q-eris-lib,m11q_eris_charon,liberis_charon))
$(eval $(call m11q-eris-lib,m11q_eris_simaka,liberis_simaka))
$(eval $(call m11q-eris-lib,m11q_eris_secril_client,libsecril-client))
