#!/bin/bash

# Update all running operating systems within Proxmox LXC containers, including Alpine Linux

# Update Proxmox itself
apt update
apt full-upgrade -y

# Get a list of all the containers
containers=$(pct list | grep running | awk '{print $1}')

# Loop through each container
for container in $containers
do
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
      pct exec $container -- bash -c "apt full-upgrade -y"
    fi
done
