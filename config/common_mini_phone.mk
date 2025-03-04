# Inherit common ZAP stuff
$(call inherit-product, vendor/zap/config/common.mk)

# Include ZAP audio files
include vendor/zap/config/cm_audio.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/zap/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/zap/config/telephony.mk)
