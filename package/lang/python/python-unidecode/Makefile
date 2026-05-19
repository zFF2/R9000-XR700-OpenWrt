include $(TOPDIR)/rules.mk

PYPI_NAME:=Unidecode
PKG_VERSION:=1.1.1
PKG_RELEASE:=2
PKG_URL:=https://github.com/avian2/unidecode
PKG_TITLE:=Unidecode, lossy ASCII transliterations of Unicode text
PKG_HASH:=2b6aab710c2a1647e928e36d69c21e76b453cd455f4e2621000e54b2a9b8cce8
PKG_MAINTAINER:=Josef Schlehofer <pepe.schlehofer@gmail.com>
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=LICENSE
PKG_DEPENDS:=+python3-light

include $(TOPDIR)/package/lang/python/Makefile.mk

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-src))
