################################################################################
#
# kodi-pvr-dvbviewer
#
################################################################################

KODI_PVR_DVBVIEWER_VERSION = 21.1.3-Omega
KODI_PVR_DVBVIEWER_SITE = $(call github,kodi-pvr,pvr.dvbviewer,$(KODI_PVR_DVBVIEWER_VERSION))
KODI_PVR_DVBVIEWER_LICENSE = GPL-2.0+
KODI_PVR_DVBVIEWER_LICENSE_FILES = LICENSE.md
KODI_PVR_DVBVIEWER_DEPENDENCIES = kodi tinyxml

$(eval $(cmake-package))
