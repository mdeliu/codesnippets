#!/bin/bash

log=/home/mu/docker/_scripts/logfile.txt

# Update the system
apt-get update
apt-get upgrade -y

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
  echo "A reboot is required."
  # Perform a reboot
  reboot
else
 echo "No reboot is required."
fi

# Log
printf "APT updates finished on " >> $log
date >> $log
