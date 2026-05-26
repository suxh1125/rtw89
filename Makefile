# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

PKG_NAME:=rtw89
PKG_RELEASE:=1

PKG_SOURCE_DATE:=2025-01-01
PKG_SOURCE_VERSION:=main
PKG_MIRROR_HASH:=skip

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/suxh1125/rtw89.git

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=linux

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rtw89
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek 8852/8851/8922 PCIe/USB WiFi driver (morrownr)
  DEPENDS:=+kmod-mac80211 @PCI_SUPPORT||USB_SUPPORT
  FILES:= \
    $(PKG_BUILD_DIR)/rtw89_core_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8851b_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8851bu_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852a_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852au_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852b_common_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852b_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852bu_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852c_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8852cu_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8922a_git.ko \
    $(PKG_BUILD_DIR)/rtw89_8922au_git.ko \
    $(PKG_BUILD_DIR)/rtw89_usb_git.ko \
    $(if $(CONFIG_RTW89_PCI), \
      $(PKG_BUILD_DIR)/rtw89_pci_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8851be_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8852ae_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8852be_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8852bt_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8852bte_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8852ce_git.ko \
      $(PKG_BUILD_DIR)/rtw89_8922ae_git.ko \
    )
  AUTOLOAD:=$(call AutoLoad,60, \
    rtw89_core_git \
    rtw89_8851b_git \
    rtw89_8852a_git \
    rtw89_8852b_git \
    rtw89_8852b_common_git \
    rtw89_8852c_git \
    rtw89_8922a_git \
    rtw89_usb_git \
    $(if $(CONFIG_RTW89_PCI),rtw89_pci_git) \
    rtw89_8851bu_git \
    rtw89_8852au_git \
    rtw89_8852bu_git \
    rtw89_8852cu_git \
    rtw89_8922au_git \
    $(if $(CONFIG_RTW89_PCI), \
      rtw89_8851be_git \
      rtw89_8852ae_git \
      rtw89_8852be_git \
      rtw89_8852bt_git \
      rtw89_8852bte_git \
      rtw89_8852ce_git \
      rtw89_8922ae_git \
    ),1)
endef

define KernelPackage/rtw89/config
  if PACKAGE_kmod-rtw89
    config RTW89_PCI
      bool "Enable PCIe bus support"
      default y
      help
        Build and load PCIe driver modules (rtw89_pci_git.ko and chip-specific PCIe modules).
    config RTW89_USB
      bool "Enable USB bus support"
      default y
      help
        USB support is always built (no extra configuration currently required).
  endif
endef

# Remove -DGIT_COMMIT line and fix build without .git
define Build/Prepare
	$(call Build/Prepare/Default)
	# Patch will be applied automatically from patches/ directory
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		CONFIG_PCI=$(if $(CONFIG_RTW89_PCI),m,n) \
		modules
endef

define KernelPackage/rtw89/install
	$(INSTALL_DIR) $(1)/lib/firmware/rtw89
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8851b_fw.bin $(1)/lib/firmware/rtw89/
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8852a_fw.bin $(1)/lib/firmware/rtw89/
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8852b_fw.bin $(1)/lib/firmware/rtw89/
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8852c_fw.bin $(1)/lib/firmware/rtw89/
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8852bt_fw.bin $(1)/lib/firmware/rtw89/
	$(CP) $(PKG_BUILD_DIR)/firmware/rtw8922a_fw.bin $(1)/lib/firmware/rtw89/
endef

$(eval $(call KernelPackage,rtw89))
