#!/bin/bash

#     Copyright (C) 2015 KreAch3R
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#          http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.


# Version: 1.0

#DON'T change these. They are required as-is for the script to function
TARGET_DEVICE=$1
otamd5=$2

# Actual important variables
site=https://basketbuild.com/devs/KreAch3R/Krexus/$TARGET_DEVICE
remotemd5=$( echo $( curl -s $site ) | sed 's/.*data-content="\(.*\)"> View MD5.*/\1/' )

echo "running"

if [ "$otamd5" == "$remotemd5" ]; then
    exit 0
else
	exit 1
fi
