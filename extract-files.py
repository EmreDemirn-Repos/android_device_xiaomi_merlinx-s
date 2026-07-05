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

namespace_imports = [
    'hardware/mediatek',
    'hardware/xiaomi',
    'device/xiaomi/merlinx',
    'vendor/xiaomi/merlinx'
]

blob_fixups: blob_fixups_user_type = {
    ('vendor/lib/hw/vendor.mediatek.hardware.pq@2.13-impl.so', 'vendor/lib64/hw/vendor.mediatek.hardware.pq@2.13-impl.so', 'vendor/lib/hw/android.hardware.thermal@2.0-impl.so', 'vendor/lib64/hw/android.hardware.thermal@2.0-impl.so'): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so')
	.replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    'vendor/lib64/libmtkcam_stdutils.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib64/libwifi-hal-mtk.so': blob_fixup()
	.fix_soname(),
    'vendor/lib64/libgf_hal.so': blob_fixup()
        .binary_regex_replace(b'\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\xff\x83\x01\xd1\xfd{\x05\xa9\xfdC\x01\x91', b'\x00\x14\xa0\x83_\xb8\xfd{C\xa9\xff\x03\x01\x91\xc0\x03_\xd6\x00\x00\xe0\xd2\xc0\x03_\xd6\xfdC\x01\x91'),
    ('vendor/lib/libaalservice.so', 'vendor/lib64/libaalservice.so', 'vendor/lib/libcam.utils.sensorprovider.so', 'vendor/lib64/libcam.utils.sensorprovider.so'): blob_fixup()
        .add_needed('libshim_sensors.so'),
    'vendor/lib64/hw/fingerprint.mt6768.so': blob_fixup()
        .binary_regex_replace(b'\xc0\x03_\xd6\x00\x00\x00\x00\xff\x03\x01\xd1\xfd{\x02\xa9', b'\xc0\x03_\xd6\x00\x00\x00\x00\xc0\x03_\xd6\xfd{\x02\xa9'),
    'vendor/lib64/libmi_watermark.so': blob_fixup()
        .add_needed('libpiex_shim.so'),
    ('vendor/lib/libwvhidl.so', 'vendor/lib64/libwvhidl.so', 'vendor/lib/mediadrm/libwvdrmengine.so', 'vendor/lib64/mediadrm/libwvdrmengine.so'): blob_fixup()
	.replace_needed('libprotobuf-cpp-lite-3.9.1', 'libprotobuf-cpp-lite-3.9.1-v31')
        .add_needed('libcrypto_shim.so'),
    'vendor/bin/hw/mtkfusionrild': blob_fixup()
	.add_needed('libutils-v32.so'),
    ('vendor/lib/libnvram.so', 'vendor/lib/libsysenv.so', 'vendor/lib64/libnvram.so', 'vendor/lib64/libsysenv.so', 'vendor/bin/hw/android.hardware.neuralnetworks@1.3-service-mtk-neuron', 'vendor/bin/hw/android.hardware.sensors@2.0-service.multihal-mediatek'): blob_fixup()
	.add_needed('libbase_shim.so'),
    ('vendor/lib64/libmtkcam_grallocutils.so', 'vendor/lib64/libmtkisp_metadata.so'): blob_fixup()
	.replace_needed('libui.so', 'libui-v34.so'),
    'vendor/etc/vintf/manifest/manifest_media_c2_V1_2_default.xml': blob_fixup()
        .regex_replace('1.1', '1.2'),
    'vendor/etc/init/android.hardware.media.c2@1.2-mediatek-64b.rc': blob_fixup()
        .regex_replace('mediatek', 'mediatek-64b'),
    'vendor/bin/hw/android.hardware.media.c2@1.2-mediatek-64b': blob_fixup()
        .replace_needed('libavservices_minijail_vendor.so', 'libavservices_minijail.so')
        .replace_needed('libcodec2_hidl@1.0.so', 'libcodec2_hidl@1.0-v31.so')
        .replace_needed('libcodec2_hidl@1.1.so', 'libcodec2_hidl@1.1-v31.so')
        .replace_needed('libcodec2_hidl@1.2.so', 'libcodec2_hidl@1.2-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
	.add_needed('libstagefright_foundation-v33.so'),
    'vendor/lib64/libcodec2_hidl@1.0-v31.so': blob_fixup()
        .replace_needed('libstagefright_bufferqueue_helper.so', 'libstagefright_bufferqueue_helper-v33.so')
        .replace_needed('libcodec2_hidl_plugin.so', 'libcodec2_hidl_plugin-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libui.so', 'libui-v34.so')
        .add_needed('libbase_shim.so'),
    'vendor/lib64/libcodec2_hidl@1.1-v31.so': blob_fixup()
        .replace_needed('libstagefright_bufferqueue_helper.so', 'libstagefright_bufferqueue_helper-v33.so')
        .replace_needed('libcodec2_hidl@1.0.so', 'libcodec2_hidl@1.0-v31.so')
        .replace_needed('libcodec2_hidl_plugin.so', 'libcodec2_hidl_plugin-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libui.so', 'libui-v34.so')
        .add_needed('libbase_shim.so'),
    'vendor/lib64/libcodec2_hidl@1.2-v31.so': blob_fixup()
        .replace_needed('libstagefright_bufferqueue_helper.so', 'libstagefright_bufferqueue_helper-v33.so')
        .replace_needed('libcodec2_hidl@1.0.so', 'libcodec2_hidl@1.0-v31.so')
        .replace_needed('libcodec2_hidl@1.1.so', 'libcodec2_hidl@1.1-v31.so')
        .replace_needed('libcodec2_hidl_plugin.so', 'libcodec2_hidl_plugin-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libui.so', 'libui-v34.so')
        .add_needed('libbase_shim.so'),
     'vendor/lib64/libcodec2_hidl_plugin-v31.so': blob_fixup()
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so'),
    ('vendor/lib64/libcodec2_mtk_c2store.so', 'vendor/lib64/libcodec2_vpp_qt_plugin.so', 'vendor/lib64/libcodec2_vpp_rs_plugin.so'): blob_fixup()
        .replace_needed('libcodec2_soft_common.so', 'libcodec2_soft_common-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libstagefright_foundation.so', 'libstagefright_foundation-v33.so')
        .replace_needed('libsfplugin_ccodec_utils.so', 'libsfplugin_ccodec_utils-v31.so'),
    ('vendor/lib64/libcodec2_mtk_vdec.so', 'vendor/lib64/libcodec2_mtk_venc.so'): blob_fixup()
        .replace_needed('libcodec2_soft_common.so', 'libcodec2_soft_common-v31.so')
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libstagefright_foundation.so', 'libstagefright_foundation-v33.so')
        .replace_needed('libsfplugin_ccodec_utils.so', 'libsfplugin_ccodec_utils-v31.so')
        .replace_needed('libui.so', 'libui-v34.so'),
    'vendor/lib64/libcodec2_soft_common-v31.so': blob_fixup()
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so')
        .replace_needed('libstagefright_foundation.so', 'libstagefright_foundation-v33.so')
        .replace_needed('libsfplugin_ccodec_utils.so', 'libsfplugin_ccodec_utils-v31.so'),
    'vendor/lib64/libcodec2_vndk-v31.so': blob_fixup()
        .replace_needed('libui.so', 'libui-v34.so')
        .replace_needed('libstagefright_foundation.so', 'libstagefright_foundation-v33.so'),
    'vendor/lib64/libsfplugin_ccodec_utils-v31.so': blob_fixup()
        .replace_needed('libcodec2_vndk.so', 'libcodec2_vndk-v31.so'),
    'vendor/bin/mnld': blob_fixup()
        .add_needed('libshim_sensors.so'),
    'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so')
        .add_needed('libbinder-v32.so'),
    'vendor/lib/librt_extamp_intf.so': blob_fixup()
        .replace_needed('libtinyxml.so', 'libtinyxml2-v34.so'),
    'vendor/lib64/libcam.hal3a.v3.so': blob_fixup()
        .replace_needed('libui.so', 'libui-v34.so')
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so'),
    ('vendor/bin/hw/android.hardware.gnss-service.mediatek', 'vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so'): blob_fixup()
	.replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so'),
    'vendor/bin/hw/android.hardware.memtrack-service.mediatek': blob_fixup()
	.replace_needed('android.hardware.memtrack-V1-ndk_platform.so', 'android.hardware.memtrack-V1-ndk.so'),
    'vendor/lib64/android.hardware.power-service-mediatek.so': blob_fixup()
	.replace_needed('android.hardware.power-V2-ndk_platform', 'android.hardware.power-V2-ndk.so'),
    'vendor/bin/factory': blob_fixup()
        .replace_needed('android.hardware.light-V1-ndk_platform.so', 'android.hardware.light-V1-ndk.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'merlinx',
    'xiaomi',
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
