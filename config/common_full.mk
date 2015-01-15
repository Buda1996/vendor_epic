# Inherit common CM stuff
$(call inherit-product, vendor/epic/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include EPIC audio files
include vendor/epic/config/cm_audio.mk

# Include EPIC LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/epic/overlay/dictionaries

# Optional EPIC-OS packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhaseBeam \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

PRODUCT_PACKAGES += \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Extra tools in EPIC-OS
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
