PRODUCT_BRAND ?= Epic-OS

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/epic/prebuilt/common/bootanimation))
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
PRODUCT_BOOTANIMATION := vendor/epic/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/epic/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
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
    persist.service.clearaudio.enable=1 \
    ro.sony.walkman.logger=1 \
    persist.service.walkman.enable=1 \
    ro.somc.clearphase.supported=true \
    persist.service.clearphase.enable=1 \
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
    vendor/epic/CHANGELOG.mkdn:system/etc/CHANGELOG-EPIC.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/epic/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/epic/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/epic/prebuilt/common/bin/50-epic.sh:system/addon.d/50-epic.sh \
    vendor/epic/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/epic/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/epic/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/epic/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/epic/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# epic-specific init file
PRODUCT_COPY_FILES += \
    vendor/epic/prebuilt/common/etc/init.local.rc:root/init.epic-os.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/epic/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/epic/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is epic!
PRODUCT_COPY_FILES += \
    vendor/epic/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# T-Mobile theme engine
include vendor/epic/config/themes_common.mk

# Required epic packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional epic packages
PRODUCT_PACKAGES += \
    VoicePlus \
    libemoji 
    

# Custom epic packages
PRODUCT_PACKAGES += \
    Launcher3 \
    AudioFX \
    CMFileManager \
    Eleven \
    LockClock \
    CMAccount 

# epic Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in epic
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
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

PRODUCT_PACKAGE_OVERLAYS += vendor/epic/overlay/common

PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0

# Set EPIC_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef EPIC_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "EPIC_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^EPIC_||g')
        EPIC_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(EPIC_BUILDTYPE)),)
    EPIC_BUILDTYPE :=
endif

ifdef EPIC_BUILDTYPE
    ifneq ($(EPIC_BUILDTYPE), SNAPSHOT)
        ifdef EPIC_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            EPIC_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from EPIC_EXTRAVERSION
            EPIC_EXTRAVERSION := $(shell echo $(EPIC_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to EPIC_EXTRAVERSION
            EPIC_EXTRAVERSION := -$(EPIC_EXTRAVERSION)
        endif
    else
        ifndef EPIC_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            EPIC_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from EPIC_EXTRAVERSION
            EPIC_EXTRAVERSION := $(shell echo $(EPIC_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to EPIC_EXTRAVERSION
            EPIC_EXTRAVERSION := -$(EPIC_EXTRAVERSION)
        endif
    endif
else
    # If EPIC_BUILDTYPE is not defined, set to UNOFFICIAL
    EPIC_BUILDTYPE := UNOFFICIAL
    EPIC_EXTRAVERSION :=
endif

ifeq ($(EPIC_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        EPIC_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(EPIC_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        EPIC_VERSION := v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(EPIC_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            EPIC_VERSION := v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(EPIC_BUILD)
        else
            EPIC_VERSION := v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(EPIC_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        EPIC_VERSION := v$(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(EPIC_BUILDTYPE)$(EPIC_EXTRAVERSION)-$(EPIC_BUILD)
    else
        EPIC_VERSION := v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(EPIC_BUILDTYPE)$(EPIC_EXTRAVERSION)-$(EPIC_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.epic-os.version=$(EPIC_VERSION) \
  ro.epic-os.releasetype=$(EPIC_BUILDTYPE) \
  ro.modversion=$(EPIC_VERSION) \
  ro.legal.url=http://epic-os.com/?page_id=28

-include vendor/epic-priv/keys/keys.mk

EPIC_DISPLAY_VERSION := $(EPIC_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(EPIC_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(EPIC_EXTRAVERSION),)
        # Remove leading dash from EPIC_EXTRAVERSION
        EPIC_EXTRAVERSION := $(shell echo $(EPIC_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(EPIC_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    EPIC_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.epic.display.version=$(EPIC_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# statistics identity
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url=http://stats.epic-os.com/ \
    ro.romstats.name=Epic-OS \
    ro.romstats.version=-$(EPIC_Version) \
    ro.romstats.askfirst=0 \
    ro.romstats.tframe=1
	
# SOKP Files
#PRODUCT_COPY_FILES += \
    #vendor/epic/prebuilt/common/app/Audio_Fx_Widget_1.1.5-signed.apk:system/app/Audio_Fx_Widget/Audio_Fx_Widget_1.1.5-signed.apk \
    #vendor/epic/prebuilt/common/app/com.krabappel2548.dolbymobile-signed.apk:system/app/Dolbymobile/com.krabappel2548.dolbymobile-signed.apk \
	#vendor/epic/prebuilt/common/app/ApexLauncher_v2.4.1beta1.apk:system/app/ApexLauncher/ApexLauncher_v2.4.1beta1.apk 
	
