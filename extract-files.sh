#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/bin/mnld)
            [ "$2" = "" ] && return 0
            "$PATCHELF" --add-needed "libshim_sensors.so" "$2"
            ;;
        vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib/librt_extamp_intf.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libtinyxml.so" "libtinyxml2-v34.so" "${2}"
            ;;
        vendor/lib64/libcam.hal3a.v3.so | vendor/lib64/libmtkcam_3rdparty.vidhance.so)
            [ "$2" = "" ] && return 0
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

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=merlinx
export DEVICE_COMMON=mt6768-common
export VENDOR=xiaomi
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
