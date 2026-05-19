# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#
include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=alpine
BOARDNAME:=Annapurna Labs Alpine
FEATURES:=squashfs nand fpu ramdisk usb pci pcie
CPU_TYPE:=cortex-a15
CPU_SUBTYPE:=neon-vfpv4
SUBTARGETS:=generic

KERNEL_PATCHVER:=6.6

KERNELNAME:=zImage Image dtbs

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES := $(filter-out uclient-fetch,$(DEFAULT_PACKAGES))

DEFAULT_PACKAGES += \
	kmod-leds-gpio kmod-gpio-button-hotplug \
	kmod-ata-ahci kmod-ata-ahci-platform \
	kmod-usb-ohci kmod-usb-ohci-pci kmod-usb2 kmod-usb2-pci kmod-usb3 kmod-usb-ledtrig-usbport \
	kmod-ath10k ath10k-firmware-qca9984 kmod-wil6210 \
	kmod-usb-storage kmod-scsi-core kmod-fs-ext4 kmod-fs-vfat kmod-fs-msdos block-mount \
	kmod-al-eth kmod-mdio-al-gpio kmod-swconfig swconfig \
	cfdisk e2fsprogs badblocks partx-utils \
	wpad-openssl uboot-envtools \

$(eval $(call BuildTarget))
