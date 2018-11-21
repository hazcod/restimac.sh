#!/usr/bin/env bash

triggerssid="$1"
destination="$2"
passFile="$3"
airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

exclusionFile="/tmp/restimac.exclusion"

if [ -z "$triggerssid" ] || [ -z "$destination" ] || [ ! -f "$passFile" ]; then
	echo "Usage: $0 <ssid> <backup-destination> <pass-file>"
	exit 1
fi

ssid=$($airport -I | grep ' SSID' | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

if [ "$ssid" != "$triggerssid" ]; then
	exit 0
fi

baseDir="/Users/$(whoami)/"
/usr/libexec/PlistBuddy \
	-c "print :UserPathsExcluded" /System/Library/CoreServices/backupd.bundle/Contents/Resources/StdExclusions.plist \
	| sed '1d;$d' | awk '{$1=$1};1' > "$exclusionFile"

echo "
Downloads/
**/.cache/
Library/
" >> "$exclusionFile"

echo "Backup up $baseDir to $destination"
restic \
	--repo "$destination" \
	backup "$baseDir" "$baseDir/Library/Preferences" \
	--exclude-file="$exclusionFile" \
	--password-file="$passFile"
