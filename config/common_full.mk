# Inherit common ZAP stuff
$(call inherit-product, vendor/zap/config/common.mk)

# Include ZAP audio files
include vendor/zap/config/cm_audio.mk

# Include ZAP LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/zap/overlay/dictionaries

# Optional ZAP packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

# Extra tools in ZAP
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
