!/bin/bash

CONTAINERS=( $(pct list | grep running | awk '{print $1}') )

apt_update() {
pct exec $CONTAINER -- bash -c "apt update && apt upgrade -y && apt autoremove -y"
}

apk_update() {
pct exec $CONTAINER -- ash -c "apk update && apk upgrade"
}

for CONTAINER in ${CONTAINERS[@]}
do
  apt_update
  apk_update
done
