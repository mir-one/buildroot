################################################################################
#
# liblo
#
################################################################################

LIBLO_VERSION = 0.32
LIBLO_SITE = http://downloads.sourceforge.net/project/liblo/liblo/$(LIBLO_VERSION)

LIBLO_LICENSE = LGPL-2.1+
LIBLO_LICENSE_FILES = COPYING
LIBLO_INSTALL_STAGING = YES

# Liblo uses atomic builtins, so we need to link with libatomic for
# the architectures who explicitly need libatomic.
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
LIBLO_CONF_ENV += LIBS="-latomic"
endif

$(eval $(autotools-package))
