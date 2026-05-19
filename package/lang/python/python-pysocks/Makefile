include $(TOPDIR)/rules.mk

PYPI_NAME:=PySocks
PKG_VERSION:=1.7.1
PKG_RELEASE:=1

PKG_URL:=https://github.com/anorov/pysocks
PKG_TITLE:=PySocks lets you send traffic through SOCKS proxy servers. \
It is a modern fork of SocksiPy with bug fixes and extra features.
PKG_HASH:=3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0
PKG_DEPENDS:=+python3-light +python3-logging +python3-openssl +python3-urllib

PKG_MAINTAINER:=Jan Pavlinec <jan.pavlinec1@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(TOPDIR)/package/lang/python/Makefile.mk

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-src))
