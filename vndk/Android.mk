LOCAL_PATH := prebuilts/vndk

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.gnss-V1-ndk_platform
LOCAL_SRC_FILES := v32/arm64/arch-arm64-armv8-a/shared/vndk-core/android.hardware.gnss-V1-ndk_platform.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 64
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.memtrack-V1-ndk_platform
LOCAL_SRC_FILES := v32/arm64/arch-arm64-armv8-a/shared/vndk-core/android.hardware.memtrack-V1-ndk_platform.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 64
include $(BUILD_PREBUILT)
