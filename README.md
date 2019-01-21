# restimac.sh
Script to backup your home directory using restic on macOS, but only when you're connected to your specific WiFi network.
This script will also ignore TimeMachine directory exclusions.
Use `always` for SSID if you want to always trigger a backup.

## Usage
```
restic init --repo sftp://server/Volumes/Backup/laptop`
echo 'password-from-above' > backup.pass` && chmod 600 backup.pass
./restimac.sh MY-WIFI sftp:@server:/Volumes/Backup/laptop/restic backup.pass
```
