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


# Version: 3.9
# dependencies:
# plowshare: https://github.com/mcrapet/plowshare
# pushbullet-bash: https://github.com/Red5d/pushbullet-bash
# ncftp: sudo apt-get install ncftp


# Variables
pushbullet=$(gettop)/vendor/krexus/utils/pushbullet.sh

function loadvariables() {
# Check the $OUT directory for .zip files and grab the latest
otalocation=$(find $OUT -maxdepth 1 -type f -name "*.zip" | xargs ls -t | head -n1)
# Strip the directory from the file name
otapackage=$(basename $otalocation)
}

function prepare() {
	loadvariables
	echo "`tput setaf 3`Uploading to $printmessage`tput sgr0`"
}

function pushbullet() {
    loadvariables
    if [ "$1" == channel ]; then
	$pushbullet push krexus link "OTA available!" "https://basketbuild.com/devs/KreAch3R/Krexus"
    else
	$pushbullet push all note "OTA available!" "$otapackage created successfully."
    fi
    }

function pushupload() {
# Quoting the variable because it may be empty
    if [[ $# -eq 0 ]]; then
    	pushbullet && zippy-upload
    else
    	pushbullet && $1-upload
    fi
}

function ftp-upload() {
	prepare
	ncftpput -f ~/.$service-credentials.cfg -b / $otalocation
	$pushbullet push all link "Upload complete: $otapackage" "$link"
}

function afh-upload() {
    printmessage="Android File host (FTP)..."
    link="http://www.androidfilehost.com"
    service="afh"
    ftp-upload
    }

function basket-upload() {
    printmessage="BasketBuild (FTP)..."
    link="https://basketbuild.com/devs/KreAch3R/Krexus"
    service="basket"
    ftp-upload
    }

function zippy-upload() {
    printmessage="Zippyshare..."
    prepare
    exec 5>&1
    local upload_url=$(plowup zippyshare --max-rate 90k $otalocation | tee >(cat - >&5))
    $pushbullet push all link "Upload complete: $otapackage" $upload_url
    }
