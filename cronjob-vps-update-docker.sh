#!/bin/bash

# Create logfile
log=/home/mu/docker/_scripts/logfile.txt
dockerpath=/home/mu/docker

# Find all directories containing a docker-compose.yml file without subfolders and ignore 'docker-old'
dirs=$(find $dockerpath -maxdepth 1 -type d ! -name "docker-old" -exec test -e "{}/docker-compose.yml" ';' -print)

# Loop through each directory and run Docker Compose commands
for dir in $dirs; do
  echo "Processing directory: $dir"
  cd $dir
  # Stop running containers
  docker-compose down
  # Pull new container images
  docker-compose pull
  # Start containers in detached mode
  docker-compose up -d
done

# Clean old Docker containers
echo "Cleaning up..."
docker image prune -a -f
docker container prune --filter "until=24h" -f

echo "All done!"

### Create logfile
printf "Docker updates finished on " >> $log
date >> $log
