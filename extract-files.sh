#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export PATCHELF_VERSION=0_17_2

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_FIRMWARE=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common)
            ONLY_COMMON=true
            ;;
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        --only-target)
            ONLY_TARGET=true
            ;;
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        lib64/libshowlogo.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libshim_showlogo.so" "${2}"
            ;;
        vendor/lib/hw/vendor.mediatek.hardware.pq@2.13-impl.so | vendor/lib64/hw/vendor.mediatek.hardware.pq@2.13-impl.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib*/libmtkcam_stdutils.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "$2"
            ;;
        vendor/lib64/libwifi-hal-mtk.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --set-soname libwifi-hal-mtk.so "${2}"
            ;;
        vendor/lib64/libgf_hal.so)
            [ "$2" = "" ] && return 0
            sed -i 's|\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\xff\x83\x01\xd1\xfd{\x05\xa9\xfdC\x01\x91|\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\x00\x00\xe0\xd2\xc0\x03_\xd6\xfdC\x01\x91|g' "${2}"
            ;;
        vendor/lib*/libaalservice.so|\
        vendor/lib*/libcam.utils.sensorprovider.so)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --add-needed "libshim_sensors.so" "$2"
            ;;
        vendor/lib64/hw/fingerprint.mt6768.so)
            [ "$2" = "" ] && return 0
            sed -i 's|\xc0\x03_\xd6\x00\x00\x00\x00\xff\x03\x01\xd1\xfd{\x02\xa9|\xc0\x03_\xd6\x00\x00\x00\x00\xc0\x03_\xd6\xfd{\x02\xa9|g' "${2}"
            ;;
	vendor/lib64/libmi_watermark.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libpiex_shim.so" "${2}"
            ;;
        system_ext/lib64/libsource.so)
            [ "$2" = "" ] && return 0
            grep -q libui_shim.so "$2" || "$PATCHELF" --add-needed libui_shim.so "$2"
            ;;
        vendor/lib*/libwvhidl.so | vendor/lib*/mediadrm/libwvdrmengine.so)
            [ "$2" = "" ] && return 0
            grep -q "libcrypto_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
            ;;
        system_ext/lib64/libimsma.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libsink.so" "libsink-mtk.so" "${2}"
            ;;
        vendor/bin/hw/mtkfusionrild)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libutils-v32.so" "${2}"
            ;;
        vendor/lib/libnvram.so | vendor/lib/libsysenv.so | vendor/lib64/libnvram.so | vendor/lib64/libsysenv.so)
       [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libbase_shim.so" "${2}"
            ;;
         vendor/lib64/libmtkcam_grallocutils.so | vendor/lib64/libmtkisp_metadata.so)
            "${PATCHELF}" --replace-needed "libui.so" "libui-v34.so" "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

if [ -z "${ONLY_FIRMWARE}" ] && [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../../${VENDOR}/${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    if [ -z "${ONLY_FIRMWARE}" ]; then
        extract "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    fi
fi

"${MY_DIR}/setup-makefiles.sh"
