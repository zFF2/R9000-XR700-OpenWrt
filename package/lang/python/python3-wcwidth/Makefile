include $(TOPDIR)/rules.mk

PYPI_NAME:=wcwidth
PKG_VERSION:=0.2.5
PKG_RELEASE:=1
PKG_URL:=https://github.com/jquast/wcwidth
PKG_HASH:=c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83
PKG_TITLE:=Terminal width calculation library
PKG_MAINTAINER:=Jan Pavlinec <jan.pavlinec1@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_DEPENDS:=+python3-light

include $(TOPDIR)/package/lang/python/Makefile.mk

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-src))
