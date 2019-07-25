#!/usr/bin/env bash

# setup input arguments
triggerssid="$1"
destination="$2"
passFile="$3"

# airport cli
airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
# temporary exclusion file
exclusionFile="/tmp/restimac.exclusion"

# check input parameters
if [ -z "$triggerssid" ] || [ -z "$destination" ] || [ ! -f "$passFile" ]; then
	echo "Usage: $0 <ssid> <backup-destination> <pass-file>"
	exit 1
fi

# get current WiFi SSID
ssid=$($airport -I | grep ' SSID' | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# check if we get our wanted SSID or 'always'
if [ "$triggerssid" == "always" ] || [ "$ssid" != "$triggerssid" ]; then
	exit 0
fi

# find home directory
baseDir="/Users/$(whoami)/"
# extract built-in TimeMachine exclusions
/usr/libexec/PlistBuddy \
	-c "print :UserPathsExcluded" /System/Library/CoreServices/backupd.bundle/Contents/Resources/StdExclusions.plist \
	| sed '1d;$d' | awk '{$1=$1};1' > "$exclusionFile"

# add some more exclusions
echo "
Downloads/
**/.cache/
Library/
" >> "$exclusionFile"

# start backup
echo "Backup up $baseDir to $destination"
/usr/local/bin/restic \
	--quiet \
	--repo "$destination" \
	backup "$baseDir" "$baseDir/Library/Preferences" \
	--exclude-file="$exclusionFile" \
	--password-file="$passFile" \
	--cleanup-cache
