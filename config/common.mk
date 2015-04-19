PRODUCT_BRAND ?= ZAP

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/zap/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/zap/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/zap/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.semc.sound_effects_enabled=true \
    ro.semc.xloud.supported=true \
    media.xloud.enable=1 \
    media.xloud.supported=true \
    ro.semc.enhance.supported=true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.enhance.enable=1 \
    ro.semc.clearaudio.supported=true \
    ro.sony.walkman.logger=1 \
    persist.service.walkman.enable=1 \
    ro.somc.clearphase.supported=true \
    af.resampler.quality=255

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product-res-path=framework/SemcGenericUxpRes.apk \
    af.resampler.quality=255 \
    ro.somc.clearphase.supported=true \
    ro.semc.xloud.supported=true \
    ro.somc.sforce.supported=true \
    ro.service.swiqi3.supported=true \
    persist.service.swiqi3.enable=1 \
    tunnel.decode=true

PRODUCT_PROPERTY_OVERRIDES += \
    tunnel.audiovideo.decode=true \
    persist.speaker.prot.enable=false \
    media.aac_51_output_enabled=true \
    dev.pm.dyn_samplingrate=1 \
    ro.HOME_APP_ADJ=1 \
    persist.sys.use_dithering=1 \
    presist.sys.font_clarity=0


PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/zap/CHANGELOG.mkdn:system/etc/CHANGELOG-ZAP.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/zap/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/zap/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/zap/prebuilt/common/bin/50-zap.sh:system/addon.d/50-zap.sh \
    vendor/zap/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/zap/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/zap/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/zap/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/zap/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# zap-specific init file
PRODUCT_COPY_FILES += \
    vendor/zap/prebuilt/common/etc/init.local.rc:root/init.zap.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/zap/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/zap/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is ZAP Based!
PRODUCT_COPY_FILES += \
    vendor/zap/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml
	
#ZAP FIles
PRODUCT_COPY_FILES += \
vendor/zap/prebuilt/fonts/Roboto-Bold.ttf:system/fonts/Roboto-Bold.ttf \
vendor/zap/prebuilt/fonts/Roboto-BoldItalic.ttf:system/fonts/Roboto-BoldItalic.ttf \
vendor/zap/prebuilt/fonts/Roboto-Italic.ttf:system/fonts/Roboto-Italic.ttf \
vendor/zap/prebuilt/fonts/Roboto-Light.ttf:system/fonts/Roboto-Light.ttf \
vendor/zap/prebuilt/fonts/Roboto-LightItalic.ttf:system/fonts/Roboto-LightItalic.ttf \
vendor/zap/prebuilt/fonts/Roboto-Regular.ttf:system/fonts/Roboto-Regular.ttf
	

# T-Mobile theme engine
include vendor/zap/config/themes_common.mk

# Required ZAP packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt \
	SonicLauncher

# Optional ZAP packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji 
    
# Custom ZAP packages
PRODUCT_PACKAGES += \
    Launcher3 \
    ZAPStats \
    SonicPapers \
    Trebuchet \
    CMHome \
    CMFileManager \
    Eleven \
    LockClock \
    CyanogenSetupWizard

# ZAP Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in ZAP
PRODUCT_PACKAGES += \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

PRODUCT_PACKAGE_OVERLAYS += vendor/zap/overlay/common

PRODUCT_VERSION_MAJOR = L-5.1-LMY47I
PRODUCT_VERSION_MINOR = R1
PRODUCT_VERSION_MAINTENANCE = 0

# Set ZAP_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef ZAP_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "ZAP_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^ZAP_||g')
        ZAP_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(ZAP_BUILDTYPE)),)
    ZAP_BUILDTYPE :=
endif

ifdef ZAP_BUILDTYPE
    ifneq ($(ZAP_BUILDTYPE), SNAPSHOT)
        ifdef ZAP_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            ZAP_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from ZAP_EXTRAVERSION
            ZAP_EXTRAVERSION := $(shell echo $(ZAP_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to ZAP_EXTRAVERSION
            ZAP_EXTRAVERSION := -$(ZAP_EXTRAVERSION)
        endif
    else
        ifndef ZAP_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            ZAP_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from ZAP_EXTRAVERSION
            ZAP_EXTRAVERSION := $(shell echo $(ZAP_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to ZAP_EXTRAVERSION
            ZAP_EXTRAVERSION := -$(ZAP_EXTRAVERSION)
        endif
    endif
else
    # If ZAP_BUILDTYPE is not defined, set to UNOFFICIAL
    ZAP_BUILDTYPE := UNOFFICIAL
    ZAP_EXTRAVERSION :=
endif

ifeq ($(ZAP_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        ZAP_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(ZAP_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        ZAP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(ZAP_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ZAP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(ZAP_BUILD)
        else
            ZAP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(ZAP_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),1)
        ZAP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(ZAP_BUILDTYPE)$(ZAP_EXTRAVERSION)-$(ZAP_BUILD)
    else
        ZAP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(ZAP_BUILDTYPE)$(ZAP_EXTRAVERSION)-$(ZAP_BUILD)
    endif
endif

ZAP_Version= L-5.1-LMY47I-R1
ZAP_MOD_VERSION := $(ZAP_Version)-$(shell date -u +%Y%m%d)$(ZAP_EXTRAVERSION)-$(ZAP_BUILD)
 
PRODUCT_PROPERTY_OVERRIDES += \
  ro.zap.version=$(ZAP_Version) \
  ro.zap.releasetype=$(ZAP_BUILDTYPE) \
  ro.modversion=$(ZAP_MOD_VERSION) \
  ro.legal.url=http://sonic-developers.com/disclaimer/

-include vendor/zap-priv/keys/keys.mk

SQUISHER_SCRIPT := vendor/zap/tools/squisher

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.zap.display.version=$(ZAP_Version)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# statistics identity
  PRODUCT_PROPERTY_OVERRIDES += \
  ro.romstats.url=http://statistics.sonic-developers.com/ \
  ro.romstats.name=ZAP \
  ro.romstats.version=-$(ZAP_Version) \
  ro.romstats.askfirst=0 \
  ro.romstats.tframe=1
