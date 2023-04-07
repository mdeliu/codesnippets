#!/bin/bash

# Paths
dockerpath="/home/mu/docker"
log="/home/mu/docker/_scripts/logfile.txt"
backup_path="/home/mu/docker"
backup_dest="/home/mu/docker/_backup"

# Find all directories containing a docker-compose.yml file, excluding 'docker-old' and stop them
dirs=$(find $dockerpath -maxdepth 1 -type d ! -name "docker-old" -exec test -e "{}/docker-compose.yml" ';' -print)
# Loop through each directory and shutdown containers
for dir in $dirs; do
  echo "Processing directory: $dir"
  cd $dir
  docker-compose down
done

# Check if backup_dest exists
if [ ! -d "$backup_dest" ]; then
  echo "Error: Directory does not exist!"
  exit 1
fi

# Delete the previously created tgz file
previous_backup=$(ls -1t "$backup_dest"/*.tgz | tail -n 1)
if [ -f "$previous_backup" ]; then
  echo "Deleting previous backup file: $previous_backup"
  rm "$previous_backup"
fi

# Set archive filename
day=$(date +%d-%m-%y)
hostname=$(hostname -s)
backup_file="$hostname-$day.tgz"

# Create tar
echo "Creating backup..."
tar -czf $backup_dest/$backup_file $backup_path

# Log
printf "Backups finished on " >> $log
date >> $log

# Find all directories containing a docker-compose.yml file, excluding 'docker-old' and start them
dirs=$(find $dockerpath -maxdepth 1 -type d ! -name "docker-old" -exec test -e "{}/docker-compose.yml" ';' -print)
# Loop through each directory and shutdown containers
for dir in $dirs; do
  echo "Processing directory: $dir"
  cd $dir
  docker-compose up -d
done