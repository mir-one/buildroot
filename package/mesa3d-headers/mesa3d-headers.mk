################################################################################
#
# mesa3d-headers
#
################################################################################

# mesa3d-headers is inherently incompatible with mesa3d, so error out
# if both are enabled.
ifeq ($(BR_BUILDING)$(BR2_PACKAGE_MESA3D)$(BR2_PACKAGE_MESA3D_HEADERS),yyy)
$(error mesa3d-headers enabled, but mesa3d enabled too)
endif

# Not possible to directly refer to mesa3d variables, because of
# first/second expansion trickery...
MESA3D_HEADERS_VERSION = 25.1.6
MESA3D_HEADERS_SOURCE = mesa-$(MESA3D_HEADERS_VERSION).tar.xz
MESA3D_HEADERS_SITE = https://archive.mesa3d.org
MESA3D_HEADERS_DL_SUBDIR = mesa3d
MESA3D_HEADERS_LICENSE = MIT, SGI, Khronos
MESA3D_HEADERS_LICENSE_FILES = docs/license.rst
MESA3D_HEADERS_CPE_ID_VENDOR = mesa3d
MESA3D_HEADERS_CPE_ID_PRODUCT = mesa

# Only installs header files
MESA3D_HEADERS_INSTALL_STAGING = YES
MESA3D_HEADERS_INSTALL_TARGET = NO

MESA3D_HEADERS_DIRS = KHR

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)

MESA3D_HEADERS_DIRS += GL

ifeq ($(BR2_PACKAGE_XORG7),y)

# Not using $(SED) because we do not want to work in-place, and $(SED)
# contains -i.
define MESA3D_HEADERS_BUILD_DRI_PC
	sed -e 's:@VERSION@:$(MESA3D_HEADERS_VERSION):' \
		$(MESA3D_HEADERS_PKGDIR)/dri.pc \
		>$(@D)/src/gallium/frontends/dri/dri.pc
endef

define MESA3D_HEADERS_INSTALL_DRI_PC
	$(INSTALL) -D -m 0644 $(@D)/include/GL/internal/dri_interface.h \
		$(STAGING_DIR)/usr/include/GL/internal/dri_interface.h
	$(INSTALL) -D -m 0644 $(@D)/src/gallium/frontends/dri/dri.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/dri.pc
endef

endif # Xorg

endif # OpenGL

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
MESA3D_HEADERS_DIRS += EGL
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
MESA3D_HEADERS_DIRS += GLES GLES2
endif

ifeq ($(BR2_PACKAGE_HAS_LIBOPENCL),y)
MESA3D_HEADERS_DIRS += CL
endif

define MESA3D_HEADERS_BUILD_CMDS
	$(MESA3D_HEADERS_BUILD_DRI_PC)
endef

define MESA3D_HEADERS_INSTALL_STAGING_CMDS
	$(foreach d,$(MESA3D_HEADERS_DIRS),\
		cp -dpfr $(@D)/include/$(d) $(STAGING_DIR)/usr/include/ || exit 1$(sep))
	$(MESA3D_HEADERS_INSTALL_DRI_PC)
endef

$(eval $(generic-package))
