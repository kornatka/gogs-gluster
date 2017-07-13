#!/bin/bash

sudo rm -rf /etc/glusterfs
sudo rm -rf /var/lib/glusterd
sudo rm -rf /var/log/glusterfs
sudo rm -rf /gluster

if [ "$(hostname)" = "daniel1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/gluster-hosts-template /gluster/hosts

sed -i "s/$ipaddr/127.0.0.1/" /gluster/hosts

docker kill daniel
docker rm daniel

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
-v "/var/lib/glusterd:/var/lib/glusterd" \
-v "/var/log/glusterfs:/var/log/glusterfs" \
-v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
-v "/dev:/dev" \
-v "/gluster/hosts:/etc/hosts" \
--name "daniel" \
gluster/gluster-centos

mkdir -p /data/gv0
if [ "$(hostname)" = "daniel3" ]; then
docker exec daniel gluster peer probe daniel1
docker exec daniel gluster peer probe daniel2

sleep 10
docker exec daniel gluster volume create gv0 replica 3 daniel1:/data/gv0 daniel2:/data/gv0 daniel3:/data/gv0
docker exec cuche gluster volume start gv0
fi

