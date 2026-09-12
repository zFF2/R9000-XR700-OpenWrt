include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-geomate
PKG_VERSION:=1.2.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Markus Hütter <mh@hudra.net>
PKG_LICENSE:=

LUCI_TITLE:=LuCI support for Geomate
LUCI_DEPENDS:=+geomate +luci-base +luci-lua-runtime +lua
LUCI_PKGARCH:=all

define Build/Compile
endef

define Package/luci-app-geomate/install
$(INSTALL_DIR) $(1)/www/luci-static/resources/view/geomate
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/www/luci-static/resources/view/geomate/view.js $(1)/www/luci-static/resources/view/geomate/view.js
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/www/luci-static/resources/view/geomate/geofilters.js $(1)/www/luci-static/resources/view/geomate/geofilters.js
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/www/luci-static/resources/view/geomate/map.html $(1)/www/luci-static/resources/view/geomate/map.html

$(INSTALL_DIR) $(1)/usr/share/luci/menu.d/
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/usr/share/luci/menu.d/luci-app-geomate.json $(1)/usr/share/luci/menu.d/luci-app-geomate.json

$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d/
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/usr/share/rpcd/acl.d/luci-app-geomate.json $(1)/usr/share/rpcd/acl.d/luci-app-geomate.json

$(INSTALL_DIR) $(1)/usr/libexec/rpcd/
$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/usr/libexec/rpcd/luci.geomate $(1)/usr/libexec/rpcd/luci.geomate
endef

define Package/luci-app-geomate/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] && exit 0
[ -x /usr/libexec/rpcd/luci.geomate ] && chmod +x /usr/libexec/rpcd/luci.geomate
[ -x /etc/init.d/rpcd ] && /etc/init.d/rpcd restart
[ -x /etc/init.d/uhttpd ] && /etc/init.d/uhttpd restart
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
