#!/bin/bash

#sudo rm -rf /etc/glusterfs
#sudo rm -rf /var/lib/glusterd
#sudo rm -rf /var/log/glusterfs
#sudo rm -rf /gluster

if [ "$(hostname)" = "nsalla1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/g-hosts /gluster/hosts

sed -i /n$(hostname)/s/$ipaddr/127.0.0.1/ /gluster/hosts


docker run \
-d --privileged \
-p "$ipaddr:24007:24007" \
-p "$ipaddr:24008:24008" \
-p "$ipaddr:49152:49152" \
-p "$ipaddr:49153:49153" \
-v "/gluster/data:/data" \
-v "/etc/glusterfs:/etc/glusterfs" \
-v "/var/lib/glusterd:/var/lib/glusterd" \
-v "/var/log/glusterfs:/var/log/glusterfs" \
-v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
-v "/dev:/dev" \
-v "/gluster/hosts:/etc/hosts" \
--name "salla" \
gluster/gluster-centos

if [ "$(hostname)" = "sallah3" ]; then
docker exec salla gluster peer probe nsalla1
docker exec salla gluster peer probe nsalla2

sleep 10
docker exec salla gluster volume create v0 replica 3 nsalla1:/data/v0 nsalla2:/data/v0 nsalla3:/data/v0
docker exec salla gluster volume start v0
fi