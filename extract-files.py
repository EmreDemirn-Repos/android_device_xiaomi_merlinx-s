#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

blob_fixups: blob_fixups_user_type = {
    'vendor/bin/mnld': blob_fixup()
        .add_needed('libshim_sensors.so'),
    'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib/librt_extamp_intf.so': blob_fixup()
	.replace_needed('libtinyxml.so', 'libtinyxml2-v34.so'),
    'vendor/lib64/libcam.hal3a.v3.so': blob_fixup()
	.replace_needed('libui.so', 'libui-v34.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'merlinx',
    'xiaomi',
    blob_fixups=blob_fixups,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
