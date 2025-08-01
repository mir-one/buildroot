################################################################################
#
# netsniff-ng
#
################################################################################

NETSNIFF_NG_VERSION = 0.6.9
NETSNIFF_NG_SITE = http://pub.netsniff-ng.org/netsniff-ng
NETSNIFF_NG_SOURCE = netsniff-ng-$(NETSNIFF_NG_VERSION).tar.xz
NETSNIFF_NG_LICENSE = GPL-2.0
NETSNIFF_NG_LICENSE_FILES = README COPYING
# Prevent netsniff-ng configure script from finding a host installed nacl
NETSNIFF_NG_CONF_ENV = \
	NACL_INC_DIR=/dev/null \
	NACL_LIB_DIR=/dev/null
NETSNIFF_NG_DEPENDENCIES = host-pkgconf libpcap libnetfilter_conntrack liburcu
NETSNIFF_NG_CONF_OPTS = --prefix=$(TARGET_DIR)/usr

ifeq ($(BR2_PACKAGE_NETSNIFF_NG_MAUSEZAHN),y)
NETSNIFF_NG_DEPENDENCIES += libcli libnet
NETSNIFF_NG_BUILD_MAKE_TARGET = all
NETSNIFF_NG_INSTALL_MAKE_TARGET = install
else
NETSNIFF_NG_BUILD_MAKE_TARGET = allbutmausezahn
NETSNIFF_NG_INSTALL_MAKE_TARGET = install_allbutmausezahn
endif

ifeq ($(BR2_PACKAGE_GEOIP),y)
NETSNIFF_NG_DEPENDENCIES += geoip
else
NETSNIFF_NG_CONF_OPTS += --disable-geoip
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
NETSNIFF_NG_DEPENDENCIES += libnl
else
NETSNIFF_NG_CONF_OPTS += --disable-libnl
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
NETSNIFF_NG_DEPENDENCIES += ncurses
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
NETSNIFF_NG_DEPENDENCIES += zlib
else
NETSNIFF_NG_CONF_OPTS += --disable-zlib
endif

# hand-written configure script and makefile
define NETSNIFF_NG_CONFIGURE_CMDS
	(cd $(@D); \
		$(NETSNIFF_NG_CONF_ENV) \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		$(NETSNIFF_NG_CONF_OPTS) \
	)
endef

define NETSNIFF_NG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(NETSNIFF_NG_BUILD_MAKE_TARGET)
endef

define NETSNIFF_NG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		PREFIX=$(TARGET_DIR)/usr ETCDIR=$(TARGET_DIR)/etc \
			-C $(@D) $(NETSNIFF_NG_INSTALL_MAKE_TARGET)
endef

$(eval $(generic-package))
