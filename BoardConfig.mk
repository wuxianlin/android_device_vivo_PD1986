#
# Copyright (C) 2017 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

include vendor/twrp/soong/makevars.mk

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55

ENABLE_CPUSETS := true
TARGET_CPU_SMP := true
TARGET_IS_64_BIT := true
TARGET_BOOTLOADER_BOARD_NAME := k6889v1_64
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := mt6885

BOARD_KERNEL_CMDLINE += bootopt=64S3,32N2,64N2 product.version=PD1986_A_6.8.13 fingerprint.abbr=11/RP1A.200720.012 region_ver=W10
# androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x40078000
BOARD_RAMDISK_OFFSET := 0x07c08000
BOARD_SECOND_OFFSET := 0xbff88000
BOARD_TAGS_OFFSET := 0x0bc08000
BOARD_DTB_OFFSET := 0x0bc08000
BOARD_KERNEL_PAGESIZE := 2048
TARGET_PREBUILT_KERNEL := device/vivo/PD1986/prebuilt/Image.gz
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_PREBUILT_DTBOIMAGE := device/vivo/PD1986/prebuilt/dtbo
BOARD_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset 0x07c08000 --second_offset 0xbff88000 --dtb_offset 0x0bc08000 --tags_offset 0x0bc08000 --header_version $(BOARD_HEADER_VERSION) --dtb device/vivo/PD1986/prebuilt/dtb
BOARD_KERNEL_IMAGE_NAME := Image.gz


# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_F2FS := true

BOARD_AVB_VBMETA_SYSTEM := system product
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_PARTITION_LIST := system product
BOARD_MAIN_SIZE := 3221225472

# Metadata
BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4

# AVB
# Android Verified Boot
BOARD_AVB_ENABLE := true
#BOARD_AVB_RECOVERY_ADD_HASH_FOOTER_ARGS := 
ifeq ($(BOARD_AVB_ENABLE), true) 
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 2
endif

# TWRP
TW_THEME := portrait_hdpi
BOARD_SUPPRESS_SECURE_ERASE := true
TW_NO_SCREEN_TIMEOUT := true
TW_DEFAULT_BRIGHTNESS := "2047"
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_USE_FSCRYPT_POLICY := 1
TW_BRIGHTNESS_PATH := "/sys/devices/platform/11015000.i2c0/i2c-0/0-0036/leds/lm3697-backlight/brightness"

# Additional binaries & libraries needed for recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    libkeymaster4 \
    libpuresoftkeymasterdevice \
    ashmemd_aidl_interface-cpp \
    libashmemd_client

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/ashmemd_aidl_interface-cpp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libashmemd_client.so

TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_RECOVERY_ADDITIONAL_RELINK_BINARY_FILES += out/target/product/$(PRODUCT_HARDWARE)/system/bin/strace
TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += out/target/product/$(PRODUCT_HARDWARE)/system/lib64/android.hardware.oemlock@1.0.so

PLATFORM_SECURITY_PATCH := 2021-08-01
PLATFORM_VERSION := 11
VENDOR_SECURITY_PATCH := 2020-03-05
BOOT_SECURITY_PATCH := 2019-06-06
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TW_USE_TOOLBOX := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TW_INCLUDE_REPACKTOOLS := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN

BOARD_AVB_RECOVERY_ADD_HASH_FOOTER_ARGS += \
 --prop com.android.build.boot.os_version:$(PLATFORM_VERSION) \
 --prop com.android.build.boot.security_patch:$(BOOT_SECURITY_PATCH) \
 --prop com.android.build.system.os_version:$(PLATFORM_VERSION) \
 --prop com.android.build.system.security_patch:$(PLATFORM_SECURITY_PATCH) \
 --prop com.android.build.vendor.security_patch:$(VENDOR_SECURITY_PATCH)