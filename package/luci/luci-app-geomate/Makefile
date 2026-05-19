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

define Package/luci-app-geomate/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] && exit 0
[ -f /usr/libexec/rpcd/luci.geomate ] && chmod 0755 /usr/libexec/rpcd/luci.geomate
[ -x /etc/init.d/rpcd ] && /etc/init.d/rpcd restart
[ -x /etc/init.d/uhttpd ] && /etc/init.d/uhttpd restart
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
