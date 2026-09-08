#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

#
# All components inherited here go to system image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

# Enable mainline checking
#
# "relaxed" rather than "strict", matching device/google/sunfish/aosp_sunfish.mk:24.
# Both levels still error when the device produces files inside generic_system.mk's
# artifact path requirement (build/make/core/artifact_path_requirements.mk:56) --
# that check is the one that matters, and it is satisfied properly by the
# PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST additions in device-common.mk.
#
# Only "true"/"strict" additionally error on allowed-list entries that go unused
# (same file, line 58). Ours are unused because vendor/lineage/config/common.mk and
# evolution.mk allowlist backuptool_ab.* and preloaded-classes for every device,
# and this product does not install them:
#
#     internal error: Device makefile includes redundant artifact path requirement
#     allowed list entries in build/make/target/product/generic_system.mk.
#         system/bin/backuptool_ab.functions
#         system/bin/backuptool_ab.sh
#         system/bin/backuptool_postinstall.sh
#         system/etc/preloaded-classes
#
# Those entries live in shared vendor/lineage config used by other devices, so
# removing them there to satisfy this product would be the wrong fix.
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

#
# All components inherited here go to vendor image
#
# TODO(b/136525499): move *_vendor.mk into the vendor makefile later
TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)

include device/google/coral/flame/device.mk

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_DEVICE := flame
PRODUCT_MANUFACTURER := Google
PRODUCT_MODEL := Pixel 4
PRODUCT_NAME := lineage_flame

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="flame-user 13 TP1A.221005.002.B2 9382335 release-keys" \
    BuildFingerprint=google/flame/flame:13/TP1A.221005.002.B2/9382335:user/release-keys \
    DeviceProduct=flame

$(call inherit-product, vendor/google/flame/flame-vendor.mk)
