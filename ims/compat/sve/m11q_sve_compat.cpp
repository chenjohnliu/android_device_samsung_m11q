#include <stdint.h>

#include <log/log.h>
#include <media/AudioTrack.h>
#include <media/AudioRecord.h>
#include <system/audio.h>

/*
 * Android 12 exported android::ui::Size::INVALID as an 8-byte Size object.
 * Samsung's CWK3 video engine references it even for audio-only SVE startup,
 * while Android 13 no longer exports the symbol from libui.
 */
extern "C" __attribute__((visibility("default")))
const int32_t m11q_android_ui_size_invalid[2]
        __asm__("_ZN7android2ui4Size7INVALIDE") = {-1, -1};

/* Samsung camera2 NDK extension absent from AOSP. Audio-only VoWiFi never
 * uses it; report unsupported if a video path probes it. */
extern "C" __attribute__((visibility("default")))
int ACameraDevice_setParameters(void *device, const void *parameters) {
    (void)device;
    (void)parameters;
    return -38; /* -ENOSYS */
}

/* Android 13 added the oneWay argument. Preserve the Android 12 behavior by
 * forwarding the old one-boolean ABI with oneWay disabled. */
extern "C" int m11q_a13_transaction_apply(void *transaction, unsigned char synchronous,
                                            unsigned char one_way)
        __asm__("_ZN7android21SurfaceComposerClient11Transaction5applyEbb");

extern "C" __attribute__((visibility("default")))
int m11q_a12_transaction_apply(void *transaction, unsigned char synchronous)
        __asm__("_ZN7android21SurfaceComposerClient11Transaction5applyEb");

int m11q_a12_transaction_apply(void *transaction, unsigned char synchronous) {
    return m11q_a13_transaction_apply(transaction, synchronous, 0);
}

/* Layout used by Samsung's libAudioFWInterface. */
struct snd_user_waveformat_t {
    uint16_t format_tag;
    uint16_t channels;
    uint32_t samples_per_sec;
    uint32_t avg_bytes_per_sec;
    uint16_t block_align;
    uint16_t bits_per_sample;
    uint16_t extra_size;
};

static_assert(sizeof(snd_user_waveformat_t) == 20,
              "Samsung wave format ABI must remain 20 bytes");

using wave_callback_t = void (*)(int, void *, void *);

static android::sp<android::AudioTrack> *g_wave_out_handle;
static android::sp<android::AudioRecord> *g_wave_in_handle;

/*
 * CWK3's libAudioFWInterface was compiled against Samsung's Android 12
 * AudioTrack class layout. Its inline sp<AudioTrack> operations pass the
 * object address directly to RefBase::incStrong(), and it reads mStatus and
 * mLatency at Android-12 offsets. On this Android 13 target AudioTrack's
 * virtual RefBase subobject is at +968, so the first inline incStrong crashes.
 *
 * Interpose only WaveOutOpen and compile it against this target's AudioTrack
 * headers. The externally visible ABI is unchanged, while sp ownership and
 * inline accessors use the target layout. The vendor implementation ignores
 * its callback argument; preserve that behavior.
 */
__attribute__((visibility("default")))
int WaveOutOpen(android::sp<android::AudioTrack> *handle,
                audio_stream_type_t stream_type,
                snd_user_waveformat_t *format,
                wave_callback_t callback,
                int *frame_count_out,
                int *latency_out) {
    (void)callback;

    if (handle == nullptr || format == nullptr ||
            frame_count_out == nullptr || latency_out == nullptr) {
        ALOGE("M11qSveCompat: WaveOutOpen invalid argument");
        return -1;
    }
    g_wave_out_handle = handle;

    if (*handle == nullptr) {
        *handle = new android::AudioTrack();
    }

    android::sp<android::AudioTrack> track = *handle;
    if (track == nullptr) {
        ALOGE("M11qSveCompat: AudioTrack allocation failed");
        return -1;
    }

    size_t frame_count = 0;
    const android::status_t min_status = android::AudioTrack::getMinFrameCount(
            &frame_count, stream_type, format->samples_per_sec);
    if (min_status != android::NO_ERROR) {
        ALOGE("M11qSveCompat: getMinFrameCount failed: %d", min_status);
        handle->clear();
        return -1;
    }
    *frame_count_out = static_cast<int>(frame_count);

    const android::sp<android::IMemory> no_shared_buffer;
    const android::status_t set_status = track->set(
            stream_type,
            format->samples_per_sec,
            static_cast<audio_format_t>(format->format_tag),
            static_cast<uint32_t>(AUDIO_CHANNEL_OUT_MONO),
            frame_count,
            AUDIO_OUTPUT_FLAG_NONE,
            nullptr,
            nullptr,
            0,
            no_shared_buffer,
            false,
            AUDIO_SESSION_ALLOCATE,
            android::AudioTrack::TRANSFER_DEFAULT,
            nullptr,
            static_cast<uid_t>(-1),
            static_cast<pid_t>(-1),
            nullptr,
            false,
            1.0f,
            AUDIO_PORT_HANDLE_NONE);
    if (set_status != android::NO_ERROR || track->initCheck() != android::NO_ERROR) {
        ALOGE("M11qSveCompat: AudioTrack set failed: %d/%d",
              set_status, track->initCheck());
        handle->clear();
        return -1;
    }

    const android::status_t start_status = track->start();
    if (start_status != android::NO_ERROR) {
        ALOGE("M11qSveCompat: AudioTrack start failed: %d", start_status);
        handle->clear();
        return -1;
    }

    *latency_out = static_cast<int>(track->latency());
    ALOGI("M11qSveCompat: WaveOutOpen target-ABI path active, frames=%zu latency=%d",
          frame_count, *latency_out);
    return 0;
}

extern "C" __attribute__((visibility("default")))
void AUDIOFW_WAVEOUTCLOSE() {
    android::sp<android::AudioTrack> *handle = g_wave_out_handle;
    if (handle == nullptr) {
        return;
    }

    android::sp<android::AudioTrack> track = *handle;
    if (track != nullptr) {
        track->stop();
    }
    handle->clear();
    g_wave_out_handle = nullptr;
}

/* CWK3's remaining-chunk callback returns the AudioTrack position in frames
 * when initCheck succeeds, or zero otherwise. Its original inline mStatus
 * read uses the Android 12 offset; keep its return behavior with the target
 * class layout instead. The getPosition status was ignored by CWK3. */
extern "C" __attribute__((visibility("default")))
uint32_t AUDIOFW_SOUNDDEVICE_GET_REMAINCHUNK() {
    if (g_wave_out_handle == nullptr || *g_wave_out_handle == nullptr) return 0;
    android::AudioTrack *track = g_wave_out_handle->get();
    if (track->initCheck() != android::NO_ERROR) return 0;
    uint32_t position = 0;
    (void)track->getPosition(&position);
    return position;
}

/* The CWK3 WaveInOpen also constructs an AudioRecord and uses inline sp<>
 * reference counting and mStatus at an Android 12 offset. Compile ownership
 * and the status check against this target's Android 13 AudioRecord layout. */
__attribute__((visibility("default")))
int WaveInOpen(android::sp<android::AudioRecord> *handle,
               audio_source_t input_source,
               snd_user_waveformat_t *format,
               wave_callback_t callback) {
    if (handle == nullptr || format == nullptr) {
        ALOGE("M11qSveCompat: WaveInOpen invalid argument");
        return -1;
    }
    g_wave_in_handle = handle;

    if (*handle == nullptr) {
        android::content::AttributionSourceState attribution;
        attribution.packageName = "com.sec.sve";
        *handle = new android::AudioRecord(attribution);
    }
    android::sp<android::AudioRecord> record = *handle;
    if (record == nullptr) {
        ALOGE("M11qSveCompat: AudioRecord allocation failed");
        return -1;
    }

    const android::status_t status = record->set(
            input_source,
            format->samples_per_sec,
            static_cast<audio_format_t>(format->format_tag),
            AUDIO_CHANNEL_IN_MONO,
            0,
            callback,
            nullptr,
            0,
            false,
            AUDIO_SESSION_ALLOCATE,
            android::AudioRecord::TRANSFER_SYNC,
            AUDIO_INPUT_FLAG_NONE,
            static_cast<uid_t>(-1),
            static_cast<pid_t>(-1),
            nullptr,
            AUDIO_PORT_HANDLE_NONE,
            MIC_DIRECTION_UNSPECIFIED,
            MIC_FIELD_DIMENSION_DEFAULT,
            0);
    const android::status_t init_status = record->initCheck();
    if (status != android::NO_ERROR || init_status != android::NO_ERROR) {
        ALOGE("M11qSveCompat: AudioRecord set failed: %d/%d", status, init_status);
        handle->clear();
        return -1;
    }
    ALOGI("M11qSveCompat: WaveInOpen target-ABI path active");
    return 0;
}

extern "C" __attribute__((visibility("default")))
void AUDIOFW_WAVEINCLOSE() {
    android::sp<android::AudioRecord> *handle = g_wave_in_handle;
    if (handle == nullptr) return;
    android::sp<android::AudioRecord> record = *handle;
    if (record != nullptr) record->stop();
    handle->clear();
    g_wave_in_handle = nullptr;
}

extern "C" __attribute__((visibility("default")))
void AUDIOFW_WAVEINHANDLE_CLEAR() {
    android::sp<android::AudioRecord> *handle = g_wave_in_handle;
    if (handle == nullptr) return;
    handle->clear();
    g_wave_in_handle = nullptr;
}
