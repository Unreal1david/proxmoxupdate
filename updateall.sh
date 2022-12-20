#!/bin/bash

# Update all running operating systems within Proxmox LXC containers, including Alpine Linux

# Get a list of all the containers
containers=$(pct list | grep running | awk '{print $1}')

# Loop through each container
for container in $containers
do
  # Check the status of the container
  status=$(pct status $container | awk '{print $2}')

  # Update the operating system only if the container is running
  if [ "$status" == "running" ]
  then
  
    # Get the operating system of the container
    os=$(pct exec $container cat /etc/os-release | grep ^ID= | cut -d'=' -f2)

    # Update the operating system
    if [ "$os" == "alpine" ]
    then
      # Update Alpine Linux
      pct exec $container -- ash -c "apk update"
      pct exec $container -- ash -c "apk upgrade"
    else
      # Update other operating systems (assume Debian-based)
      pct exec $container -- bash -c "apt update"
      pct exec $container -- bash -c "apt upgrade -y"
    fi

  fi
done

