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

include $(CLEAR_VARS)
LOCAL_MODULE := libstagefright_foundation-v33
LOCAL_MULTILIB := both
LOCAL_SRC_FILES_arm := v33/arm64/arch-arm-armv8-a/shared/vndk-core/libstagefright_foundation.so
LOCAL_SRC_FILES_arm64 := v33/arm64/arch-arm64-armv8-a/shared/vndk-core/libstagefright_foundation.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm arm64
LOCAL_MODULE_TAGS := optional
LOCAL_CHECK_ELF_FILES := false
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)
