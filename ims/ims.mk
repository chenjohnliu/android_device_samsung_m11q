# Stage 1A/1B: package/signing, private ARM32 JNI payload, imsd and the exact
# M115F CWK3 GSMA/RCS OpenAPI shared library required by imsservice.
# SVE, ImsLogger, ImsSettings and the Android IMS facade remain deferred.
PRODUCT_PACKAGES += \
    imsservice \
    imsmanager \
    rcsopenapi \
    vsimmanager \
    EpdgManager \
    imsmanager_library.xml \
    rcsopenapi_library.xml \
    vsimservice_library.xml \
    epdgmanager_library.xml \
    m11q_floating_feature.xml \
    m11q_cscfeature.xml \
    m11q_carrier_feature.json \
    privapp-permissions-com.sec.imsservice.xml \
    imsd \
    m11q_ims_multiclientd \
    m11q_ims_radio_bridge_2_0 \
    m11q_ims_radio_bridge_2_1 \
    android.hardware.radio@1.0 \
    libhidltransport \
    libhwbinder

# Exact value from the SM-M115F CWK3 /system/build.prop. Build.VERSION.SEM_INT
# retains its exact stock missing-property default (522), while this device
# product supplies the matching One UI framework compatibility level (3101).
PRODUCT_SYSTEM_PROPERTIES += \
    ro.build.version.sem=3101
