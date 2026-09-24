#include <stdint.h>

/*
 * Samsung's frame-capture helper depends on Android 12 SurfaceComposer
 * internals. VoWiFi audio does not use frame capture, but the video engine has
 * hard DT_NEEDED/symbol references to it. Export the exact ABI and report the
 * video-only operations as unsupported.
 */
#define VIDEO_UNSUPPORTED(name, symbol) \
    __attribute__((visibility("default"))) int name(void) __asm__(symbol); \
    int name(void) { return -38; }

VIDEO_UNSUPPORTED(m11q_set_display_rotation,
        "_Z18setDisplayRotationRKN7android2spINS_7IBinderEEES4_ii")
VIDEO_UNSUPPORTED(m11q_prepare_virtual_display,
        "_Z21prepareVirtualDisplayRKN7android2ui12DisplayStateERKNS_2spINS_22IGraphicBufferProducerEEEPNS4_INS_7IBinderEEEii")
VIDEO_UNSUPPORTED(m11q_frame_output_create_input_surface,
        "_ZN7android11FrameOutput18createInputSurfaceEiiPNS_2spINS_22IGraphicBufferProducerEEE")
VIDEO_UNSUPPORTED(m11q_frame_output_copy_frame,
        "_ZN7android11FrameOutput9copyFrameEPhlb")
VIDEO_UNSUPPORTED(m11q_egl_window_make_current,
        "_ZNK7android9EglWindow11makeCurrentEv")

__attribute__((visibility("default"), aligned(4)))
uintptr_t m11q_frame_output_vtt[4]
        __asm__("_ZTTN7android11FrameOutputE") = {0};

__attribute__((visibility("default"), aligned(4)))
uint8_t m11q_frame_output_vtable[92]
        __asm__("_ZTVN7android11FrameOutputE") = {0};
