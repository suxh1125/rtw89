#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtw89
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2026-05-05
PKG_SOURCE_URL:=https://github.com/suxh1125/rtw89.git
PKG_SOURCE_VERSION:=main
PKG_MIRROR_HASH:=skip

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

# ---------- 公共元包（用于展示） ----------
define KernelPackage/rtw89-default
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek rtw89 family driver
  DEPENDS:=@(LINUX_6_6||LINUX_6_12) +kmod-mac80211 \
	+@DRIVER_11N_SUPPORT +@DRIVER_11AC_SUPPORT +@DRIVER_11AX_SUPPORT
endef

# ---------- 核心模块 ----------
define KernelPackage/rtw89-core
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_core_git.ko
endef

# ---------- USB 核心 ----------
define KernelPackage/rtw89-usb
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_usb_git.ko
  DEPENDS+=+kmod-usb-core
endef

# ---------- PCIe 核心 ----------
define KernelPackage/rtw89-pci
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_pci_git.ko
  DEPENDS+=+kmod-pci
endef

# ---------- 芯片模块定义 ----------
# 8851B 系列
define KernelPackage/rtw89-8851b
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8851b_git.ko
  DEPENDS+=+kmod-rtw89-core
endef

define KernelPackage/rtl8851bu
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8851BU support (USB)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-usb +kmod-rtw89-8851b
  FILES:= $(PKG_BUILD_DIR)/rtw89_8851bu_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8851bu_git)
endef

define KernelPackage/rtl8851be
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8851BE support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8851b
  FILES:= $(PKG_BUILD_DIR)/rtw89_8851be_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8851be_git)
endef

# 8852A 系列
define KernelPackage/rtw89-8852a
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852a_git.ko
  DEPENDS+=+kmod-rtw89-core
endef

define KernelPackage/rtl8852au
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852AU support (USB)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-usb +kmod-rtw89-8852a
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852au_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852au_git)
endef

define KernelPackage/rtl8852ae
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852AE support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8852a
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852ae_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852ae_git)
endef

# 8852B 系列
define KernelPackage/rtw89-8852b-common
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852b_common_git.ko
  DEPENDS+=+kmod-rtw89-core
endef

define KernelPackage/rtw89-8852b
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852b_git.ko
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-8852b-common
endef

define KernelPackage/rtl8852bu
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852BU support (USB)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-usb +kmod-rtw89-8852b-common +kmod-rtw89-8852b
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852bu_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852bu_git)
endef

define KernelPackage/rtl8852be
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852BE support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8852b-common +kmod-rtw89-8852b
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852be_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852be_git)
endef

define KernelPackage/rtl8852bt
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852BT support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8852b-common +kmod-rtw89-8852b
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852bt_git.ko $(PKG_BUILD_DIR)/rtw89_8852bte_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852bt_git rtw89_8852bte_git)
endef

# 8852C 系列
define KernelPackage/rtw89-8852c
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852c_git.ko
  DEPENDS+=+kmod-rtw89-core
endef

define KernelPackage/rtl8852cu
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852CU support (USB)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-usb +kmod-rtw89-8852c
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852cu_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852cu_git)
endef

define KernelPackage/rtl8852ce
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8852CE support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8852c
  FILES:= $(PKG_BUILD_DIR)/rtw89_8852ce_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8852ce_git)
endef

# 8922A 系列
define KernelPackage/rtw89-8922a
  $(KernelPackage/rtw89-default)
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/rtw89_8922a_git.ko
  DEPENDS+=+kmod-rtw89-core
endef

define KernelPackage/rtl8922au
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8922AU support (USB)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-usb +kmod-rtw89-8922a
  FILES:= $(PKG_BUILD_DIR)/rtw89_8922au_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8922au_git)
endef

define KernelPackage/rtl8922ae
  $(KernelPackage/rtw89-default)
  TITLE:=Realtek RTL8922AE support (PCIe)
  DEPENDS+=+kmod-rtw89-core +kmod-rtw89-pci +kmod-rtw89-8922a
  FILES:= $(PKG_BUILD_DIR)/rtw89_8922ae_git.ko
  AUTOLOAD:=$(call AutoProbe,rtw89_8922ae_git)
endef

# ---------- 编译步骤 ----------
define Build/Prepare
	$(call Build/Prepare/Default)
	# 移除上游 Makefile 对 .git 目录的依赖
	sed -i '/DGIT_COMMIT=/d' $(PKG_BUILD_DIR)/Makefile
endef

define Build/Compile
	$(MAKE) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		NOSTDINC_FLAGS=" \
			$(KERNEL_NOSTDINC_FLAGS) \
			-I$(PKG_BUILD_DIR) \
			-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
			-I$(STAGING_DIR)/usr/include/mac80211-backport \
			-I$(STAGING_DIR)/usr/include/mac80211/uapi \
			-I$(STAGING_DIR)/usr/include/mac80211 \
			-include backport/autoconf.h \
			-include backport/backport.h \
			-DBUILD_OPENWRT \
		" \
		modules
endef

# ---------- 固件安装 ----------
define KernelPackage/rtl8851bu/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware/rtw8851b_fw.bin $(1)/lib/firmware/rtw89
endef

define KernelPackage/rtl8852au/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware/rtw8852a_fw.bin $(1)/lib/firmware/rtw89
endef

define KernelPackage/rtl8852bu/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware/rtw8852b_fw.bin $(1)/lib/firmware/rtw89
endef

define KernelPackage/rtl8852cu/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware/rtw8852c_fw.bin $(1)/lib/firmware/rtw89
endef

define KernelPackage/rtl8922au/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware/rtw8922a_fw.bin $(1)/lib/firmware/rtw89
endef

# ---------- 注册所有包 ----------
$(eval $(call KernelPackage,rtw89-core))
$(eval $(call KernelPackage,rtw89-usb))
$(eval $(call KernelPackage,rtw89-pci))
$(eval $(call KernelPackage,rtw89-8851b))
$(eval $(call KernelPackage,rtl8851bu))
$(eval $(call KernelPackage,rtl8851be))
$(eval $(call KernelPackage,rtw89-8852a))
$(eval $(call KernelPackage,rtl8852au))
$(eval $(call KernelPackage,rtl8852ae))
$(eval $(call KernelPackage,rtw89-8852b-common))
$(eval $(call KernelPackage,rtw89-8852b))
$(eval $(call KernelPackage,rtl8852bu))
$(eval $(call KernelPackage,rtl8852be))
$(eval $(call KernelPackage,rtl8852bt))
$(eval $(call KernelPackage,rtw89-8852c))
$(eval $(call KernelPackage,rtl8852cu))
$(eval $(call KernelPackage,rtl8852ce))
$(eval $(call KernelPackage,rtw89-8922a))
$(eval $(call KernelPackage,rtl8922au))
$(eval $(call KernelPackage,rtl8922ae))
