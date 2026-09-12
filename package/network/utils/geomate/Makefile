include $(TOPDIR)/rules.mk

PKG_NAME:=geomate
PKG_VERSION:=1.2.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_SOURCE_URL:=https://codeload.github.com/hudra0/$(PKG_NAME)/tar.gz/$(PKG_SOURCE_VERSION)?
PKG_HASH:=6dfb1e15833fbcd14e5571c78815e62e62d63f38d1f7c961491c0c382dbe9669

PKG_MAINTAINER:=Markus Hütter <mh@hudra.net>
PKG_LICENSE:=

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/geomate
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Geographic IP filtering for game servers
  DEPENDS:=+curl +jq @nftables
  PKGARCH:=all
  URL:=https://github.com/hudra0/geomate
endef

define Package/geomate/description
  Geomate provides geographic IP filtering capabilities for game servers
  and other network services.
endef

define Package/geomate/conffiles
/etc/config/geomate
endef

define Package/geomate/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] && exit 0
[ -x /etc/geolocate.sh ] && /etc/geolocate.sh
[ -x /etc/init.d/geomate ] && \
/etc/init.d/geomate enable && \
sleep 2 && \
/etc/init.d/geomate start && \
exit 0
endef

define Build/Compile
endef

define Package/geomate/install
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/init.d/geomate $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/etc/config/geomate $(1)/etc/config/
	
	$(INSTALL_DIR) $(1)/etc/geomate.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geomate.d/*.txt $(1)/etc/geomate.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geomate.sh $(1)/etc/
	
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geomate_trigger.sh $(1)/etc/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geolocate.sh $(1)/etc/
endef

$(eval $(call BuildPackage,geomate))
