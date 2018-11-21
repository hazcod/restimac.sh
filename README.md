# restimac.sh
Script to backup using restic on macOS

## Usage
`restic init --repo sftp://server/Volumes/Backup/laptop`

`echo 'password-from-above' > backup.pass`

`./restimac.sh MY-WIFI sftp://server/Volumes/Backup/laptop backup.pass`
