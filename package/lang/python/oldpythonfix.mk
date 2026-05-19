PYPI_NAME:=$(shell echo "$(PYPI_NAME)" | tr '[:upper:]' '[:lower:]')
PKG_NAME:=python3-$(PYPI_NAME)

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/$(PKG_NAME)
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=$(PKG_TITLE)
  URL:=$(PKG_URL)
  DEPENDS:=$(PKG_DEPENDS)
  PROVIDES:=+@$(PKG_NAME) +@python-$(PYPI_NAME)
endef

define Package/$(PKG_NAME)/description
  $(PKG_TITLE)
endef

define Package/$(PKG_NAME)-src
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=$(PKG_TITLE) (source code)
  URL:=$(PKG_URL)
  DEPENDS:=+$(PKG_NAME)
endef

define Package/$(PKG_NAME)-src/description
  $(PKG_TITLE) (source code)
endef

