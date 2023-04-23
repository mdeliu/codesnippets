#!/bin/bash

# Paths
dockerpath="/home/mu/docker"
log="/home/mu/docker/_scripts/logfile.txt"

### Find all directories containing a docker-compose.yml file, excluding 'docker-old' and stop them
dirs=$(find $dockerpath -maxdepth 1 -type d ! -name "docker-old" -exec test -e "{}/docker-compose.yml" ';' -print)
# Loop through each directory and shutdown containers
for dir in $dirs; do
  echo "Processing directory: $dir"
  cd $dir
  docker-compose down
done

##
## --- Borg basic setup
## ssh-keygen -t ed25519 -C "borg-storagebox"
## enter filename for key
## mv ed25519borg /home/mu/.ssh && mv ed25519borg.pub /home/mu/.ssh
## ssh -p 23 <username>@<server> mkdir .ssh
## scp -P 23 ed25519borg.pub <username>@<server>:.ssh/authorized_keys
## ssh -p 23 -i /home/mu/.ssh/ed25519borg.pub <username>@<server> mkdir -p md/vps
## export BORG_RSH='ssh -i /home/mu/.ssh/ed25519borg'
## export BORG_PASSPHRASE="<passphrase>"
## borg init --encryption=repokey ssh://<username>@<server>:23/./md/vps
##
## --- Recovery example
## borg list ssh://<username>@<server>:23/./md/vps
## ssh://<username>@<server>:23/./md/vps::docker-backup-$(date +%Y-%m-%d_%H-%M-%S)
##

### Set variables for BorgBackup
export BORG_PASSPHRASE="<passphrase>"
export BORG_RSH='ssh -i /home/mu/.ssh/ed22519borg'
REPOSITORY="ssh://<username>@<server>:23/./md/vps"

### Set variables for backup
export BACKUP_SOURCE="/home/mu/docker"
export BACKUP_NAME="docker-backup-$(date +%Y-%m-%d_%H-%M-%S)"

### Create a new backup archive
borg create --stats -v $REPOSITORY::$BACKUP_NAME $BACKUP_SOURCE

### Prune old backups to keep only the latest 7 daily, 4 weekly, and 6 monthly backups
borg prune --list $REPOSITORY --keep-daily=7 --keep-weekly=4 --keep-monthly=6

### Unset BorgBackup variables for security
unset BORG_PASSPHRASE
unset BORG_REPO

### Log
printf "Backups finished on " >> $log
date >> $log

### Find all directories containing a docker-compose.yml file, excluding 'docker-old' and start them
dirs=$(find $dockerpath -maxdepth 1 -type d ! -name "docker-old" -exec test -e "{}/docker-compose.yml" ';' -print)
# Loop through each directory and shutdown containers
for dir in $dirs; do
  echo "Processing directory: $dir"
  cd $dir
  docker-compose up -d
done