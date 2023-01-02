#!/usr/bin/env bash
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#


FDEVICE="x695"
#set -o xtrace

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then 
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" ] && [ -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

# Dirty Fix: Only declare orangefox vars when needed
if [ -f "$(gettop)/bootable/recovery/orangefox.cpp" ]
then
	echo -e "\x1b[96mSetting up OrangeFox build vars...\x1b[m"
	if [ "$1" = "$FDEVICE" ] || [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	 	export OF_FLASHLIGHT_ENABLE=0
		export ALLOW_MISSING_DEPENDENCIES=true
		export OF_USE_GREEN_LED=0
		export OF_HIDE_NOTCH=1
		export OF_MAINTAINER="Woomymy"
		export OF_USE_MAGISKBOOT=1
		export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
		export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
		export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
		export OF_NO_MIUI_PATCH_WARNING=1
		export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=1
	    export OF_USE_TWRP_SAR_DETECT=1
		export OF_NO_SAMSUNG_SPECIAL=1
		export OF_QUICK_BACKUP_LIST="/boot;/data;"
	    export FOX_DELETE_AROMAFM=1
	    export FOX_ENABLE_APP_MANAGER=1
		export FOX_USE_NANO_EDITOR=1
	    # OTA
	    export OF_KEEP_DM_VERITY=1
		export OF_SKIP_FBE_DECRYPTION_SDKVERSION=31
	    export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
	    export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
	    export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
		export OF_ENABLE_LPTOOLS=1
		# screen settings
		export OF_SCREEN_H=2460
		export OF_STATUS_H=100
		export OF_ALLOW_DISABLE_NAVBAR=0 # We don't have physical buttons
		export OF_STATUS_INDENT_LEFT=48
		export OF_STATUS_INDENT_RIGHT=48
		export OF_CLOCK_POS=1
		export OF_PATCH_AVB20=1
		export FOX_VERSION=R11.1_1
		# run a process after formatting data to work-around MTP issues
		export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800"
		export OF_AB_DEVICE=1
		export OF_DONT_PATCH_ON_FRESH_INSTALLATION=1
		export FOX_USE_SPECIFIC_MAGISK_ZIP="$(gettop)/device/infinix/x695/Magisk/Magisk.zip"

		export BUNDLED_MAGISK_VER="25.2"
        export BUNDLED_MAGISK_SUM="0bdc32918b6ea502dca769b1c7089200da51ea1def170824c2812925b426d509" # Sha256 sum of the prebuilt magisk

            if [ -f "${FOX_USE_SPECIFIC_MAGISK_ZIP}" -a "$(sha256sum "${FOX_USE_SPECIFIC_MAGISK_ZIP}" 2>/dev/null | awk '{print $1}')" != "${BUNDLED_MAGISK_SUM}" ]
            then
                echo -e "\e[96m[INFO]: Removing invalid magisk zip\e[m"
                rm -v "${FOX_USE_SPECIFIC_MAGISK_ZIP}"
            fi
		if [[ ! -f "${FOX_USE_SPECIFIC_MAGISK_ZIP}" ]]
        then
            # Download prebuilt magisk for OrangeFox builds
            echo -e "\e[96m[INFO]: Downloading Magisk v${BUNDLED_MAGISK_VER}\e[m"
            
            if [[ "$(command -v "curl")" ]]
            then
                if [[ ! -d "$(dirname "${FOX_USE_SPECIFIC_MAGISK_ZIP}")" ]]
                then
                    mkdir -p "$(dirname "${FOX_USE_SPECIFIC_MAGISK_ZIP}")"
                fi

                # Download magisk and verify it
                curl -L --progress-bar "https://github.com/topjohnwu/Magisk/releases/download/v${BUNDLED_MAGISK_VER}/Magisk-v${BUNDLED_MAGISK_VER}.apk" -o "${FOX_USE_SPECIFIC_MAGISK_ZIP}"
                DOWNLOADED_SUM="$(sha256sum "${FOX_USE_SPECIFIC_MAGISK_ZIP}" | awk '{print $1}')"
                
                if [[ "${DOWNLOADED_SUM}" != "${BUNDLED_MAGISK_SUM}" ]]
                then
                    echo -e "\e[91m[ERROR]: Donwloaded Magisk ZIP seems *corrupted*, removing it to protect user's safety\e[m"
                    rm "${FOX_USE_SPECIFIC_MAGISK_ZIP}"
                    unset "FOX_USE_SPECIFIC_MAGISK_ZIP"
                else
                    echo -e "\e[96m[INFO]: Downloaded Magisk v${BUNDLED_MAGISK_VER}\e[m"
                fi
            else
                # Curl is supposed to be installed according to "Establishing a build environnement" section in AOSP docs
                # If it isn't, warn the builder about it and fallback to default Magisk ZIP
                echo -e "\e[91m[ERROR]: Curl not found!\e[m"
                unset "FOX_USE_SPECIFIC_MAGISK_ZIP"
            fi
        fi
	fi
fi

