# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Nils Andreas Svee

include $(TOPDIR)/rules.mk

PKG_NAME:=sqm-autorate
PKG_VERSION:=0.6.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/$(PKG_NAME)/$(PKG_NAME)/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=acbaf29e98823bcd29cba5645761c3f9296a1422d45c231a6daee136a6bbb34f

PKG_MAINTAINER:=Nils Andreas Svee <contact@lochnair.net>
PKG_LICENSE:=MPL

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/sqm-autorate
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Automatic adjustment of CAKE B/W
  DEPENDS:=+libuci-lua +lua +lualanes +luaposix +lua-bit32 +lua-vstruct
  PKGARCH:=all
  URL:=https://github.com/sqm-autorate/sqm-autorate
endef

define Package/sqm-autorate/conffiles
/etc/config/sqm-autorate
endef

define Package/sqm-autorate/description
  Adjusts bandwidth for CAKE by measuring load and RTT times
endef

define Package/sqm-autorate/postinst
#!/bin/sh
echo "Configuration script can be found at /usr/lib/sqm-autorate/configure.sh"
exit 0
endef

define Build/Compile
endef

define Package/sqm-autorate/install
	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d $(1)/usr/lib/sqm-autorate
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/lib/*.csv \
		$(1)/usr/lib/sqm-autorate/
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/lib/*.lua \
		$(1)/usr/lib/sqm-autorate/
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/lib/*.sh \
		$(1)/usr/lib/sqm-autorate/
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/service/sqm-autorate.service \
		$(1)/etc/init.d/sqm-autorate
	$(INSTALL_CONF) \
		$(PKG_BUILD_DIR)/config/sqm-autorate.config \
		$(1)/etc/config/sqm-autorate
endef

$(eval $(call BuildPackage,sqm-autorate))
