################################################################################
#
# libjxl
#
################################################################################

LIBJXL_VERSION = 0.7.0
LIBJXL_SITE = $(call github,libjxl,libjxl,v$(LIBJXL_VERSION))
LIBJXL_LICENSE = BSD-3-Clause
LIBJXL_LICENSE_FILES = LICENSE PATENTS
LIBJXL_CPE_ID_VENDOR = libjxl_project
LIBJXL_INSTALL_STAGING = YES

LIBJXL_DEPENDENCIES = \
	brotli \
	lcms2 \
	highway

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBJXL_DEPENDENCIES += libpng
endif

LIBJXL_CONF_OPTS = \
	-DJPEGXL_BUNDLE_LIBPNG=OFF \
	-DJPEGXL_BUNDLE_SKCMS=OFF \
	-DJPEGXL_ENABLE_DOXYGEN=OFF \
	-DJPEGXL_ENABLE_JNI=OFF \
	-DJPEGXL_ENABLE_MANPAGES=OFF \
	-DJPEGXL_ENABLE_OPENEXR=OFF \
	-DJPEGXL_ENABLE_SJPEG=OFF \
	-DJPEGXL_ENABLE_SKCMS=OFF

ifeq ($(BR2_PACKAGE_JPEG_TURBO),y)
LIBJXL_DEPENDENCIES += jpeg-turbo
LIBJXL_CONF_OPTS += -DCMAKE_DISABLE_FIND_PACKAGE_JPEG=OFF
else
LIBJXL_CONF_OPTS += -DCMAKE_DISABLE_FIND_PACKAGE_JPEG=ON
endif

$(eval $(cmake-package))
