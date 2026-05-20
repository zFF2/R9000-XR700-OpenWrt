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
  DEPENDS:=+curl +jq +nftables
  PKGARCH:=all
  URL:=https://github.com/hudra0/geomate
endef

define Package/geomate/description
  Geomate provides geographic IP filtering capabilities for game servers
  and other network services.
endef

define Package/geomate/conffiles
/etc/config/geomate
/etc/geomate.d/bf6_servers.txt
/etc/geomate.d/cod_servers.txt
/etc/geomate.d/fortnite_servers.txt
endef

define Package/geomate/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] && exit 0

[ -x /usr/libexec/geomate/geolocate.sh ] && /usr/libexec/geomate/geolocate.sh || true

if [ -x /etc/init.d/geomate ]; then
	/etc/init.d/geomate start || true
	/etc/init.d/geomate enable || true
	uci -q set geomate.global.enabled='1' || true
	uci -q commit geomate || true
fi
exit 0
endef

define Build/Compile
endef

define Package/geomate/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/init.d/geomate $(1)/etc/init.d
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/etc/config/geomate $(1)/etc/config/geomate

	$(INSTALL_DIR) $(1)/usr/libexec/geomate
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geomate.sh $(1)/usr/libexec/geomate/geomate.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geomate_trigger.sh $(1)/usr/libexec/geomate/geomate_trigger.sh
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/etc/geolocate.sh $(1)/usr/libexec/geomate/geolocate.sh
	
	$(INSTALL_DIR) $(1)/etc/geomate.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/etc/geomate.d/*.txt $(1)/etc/geomate.d
	# Package-managed builds do not use Geomate self-updater manifests.
	# Ship marker files so init script integrity checks do not fail on missing paths.
	touch $(1)/etc/geomate.d/backend_reg.md5
	touch $(1)/etc/geomate.d/frontend_reg.md5

	ln -sf /usr/libexec/geomate/geomate.sh $(1)/etc/geomate.sh
	ln -sf /usr/libexec/geomate/geomate_trigger.sh $(1)/etc/geomate_trigger.sh
	ln -sf /usr/libexec/geomate/geolocate.sh $(1)/etc/geolocate.sh
endef

$(eval $(call BuildPackage,geomate))
