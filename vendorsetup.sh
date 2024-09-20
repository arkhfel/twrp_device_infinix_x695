#
# Copyright (C) 2023 The OrangeFox Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FDEVICE="x695"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    export TW_DEFAULT_LANGUAGE="en"
    export OF_DEVICE_ALT="X695,Infinix-X695"
	export LC_ALL="C"
	export FOX_OF_AB_DEVICE=1
	export FOX_EXTREME_SIZE_REDUCTION=1
	export ALLOW_MISSING_DEPENDENCIES=true
	export OF_QUICK_BACKUP_LIST="/data;"
	export OF_USE_MAGISKBOOT=1
	export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
	export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
	export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
	export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_NANO_EDITOR=1
	export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=1
	export OF_CLOCK_POS=1
	export FOX_DELETE_AROMAFM=1
	export OF_USE_GREEN_LED=0
	export FOX_ENABLE_APP_MANAGER=1
    export FOX_USE_XZ_UTILS=1
	
	# OTA
    #export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
    export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1

	# encryption
	export OF_DISABLE_FORCED_ENCRYPTION=1
	export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION=1
	
	# screen settings
	export OF_SCREEN_H=2340
	export OF_STATUS_H=80
	export OF_CLOCK_POS=2
	export OF_STATUS_INDENT_LEFT=48
	export OF_STATUS_INDENT_RIGHT=48

	# Bootimage Partition path
	export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	
	# flashlight
	export OF_FLASHLIGHT_ENABLE=0

	# Android 12 Encryption *temporary use until binary.xml file will implement* #
	export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1
	export OF_SKIP_FBE_DECRYPTION_SDKVERSION=34 # Don't try to decrypt A14(?)
    
	# R11
	export FOX_VERSION="0.0.1"
	export FOX_VARIANT=Alpha
	export OF_PATCH_AVB20=1
	export OF_MAINTAINER="arkhfel"
	export OF_ADVANCED_SECURITY=1
	export OF_USE_TWRP_SAR_DETECT=1

	# run a process after formatting data to work-around MTP issues
	export OF_RUN_POST_FORMAT_PROCESS=1

	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
  	   export | grep "FOX" >> $FOX_BUILD_LOG_FILE
  	   export | grep "OF_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TW_" >> $FOX_BUILD_LOG_FILE
 	fi

fi
#
