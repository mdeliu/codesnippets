#!/bin/bash

# Paths
backup_dest="/home/mu/docker/_backup"
log="/home/mu/docker/_scripts/logfile.txt"

# Delete the previously created gpg file
previous_backup=$(ls -1t "$backup_dest"/*.tgz.gpg | tail -n 1)
if [ -f "$previous_backup" ]; then
  echo "Deleting previous encrypted backup file: $previous_backup"
  rm "$previous_backup"
  echo "Done!"
fi

# Set tgz filename
day=$(date +%d-%m-%y)
hostname=$(hostname -s)
backup_file="$hostname-$day.tgz"

# Encrypt
echo "Encrypt backup file: $backup_file"
gpg -c --batch --passphrase ENTERYOURPASSPHRASEHERE "$backup_dest/$backup_file"

# Delete the previously created tgz file
previous_backup_decr=$(ls -1t "$backup_dest"/*.tgz | tail -n 1)
if [ -f "$previous_backup_decr" ]; then
  echo "Deleting previous backup file: $previous_backup_decr"
  rm "$previous_backup_decr"
fi

# Upload encrypted backup to OneDrive
# Hint: copy ~/.config/rclone/rclone.conf to /root/.config/rclone/rclonf.conf
echo "Upload encrypted backup file: "$backup_file".gpg"
rclone copy $backup_dest onedrive:backup --progress

# Log
printf "Backup upload finished on " >> $log
date >> $log