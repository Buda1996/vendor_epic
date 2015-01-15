# Inherit common EPIC stuff
$(call inherit-product, vendor/epic/config/common.mk)

# Include EPIC audio files
include vendor/epic/config/cm_audio.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/epic/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
