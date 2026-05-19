include $(TOPDIR)/rules.mk

PYPI_NAME:=more-itertools
PKG_VERSION:=11.0.2
PKG_RELEASE:=1

PKG_URL:=https://github.com/erikrose/more-itertools
PKG_TITLE:=More routines for operating on iterables, beyond itertools
PKG_HASH:=392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804
PKG_DEPENDS:=+python3-light

PKG_MAINTAINER:=Jan Pavlinec <jan.pavlinec1@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(TOPDIR)/package/lang/python/oldpythonfix.mk

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-src))
