#!/bin/bash

if [ "$(hostname)" = "hassan1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/gluster-hosts-template /gluster/hosts

sed -i /g$(hostname)/s/$ipaddr/127.0.0.1/ /gluster/hosts


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
--name "hassan" \
gluster/gluster-centos



if [ "$(hostname)" = "hassan3" ]; then
docker exec hassan gluster peer probe ghassan1
docker exec hassan gluster peer probe ghassan2

sleep 10
docker exec hassan gluster volume create gv0 replica 3 ghassan1:/data/gv0 ghassan2:/data/gv0 ghassan3:/data/gv0
docker exec hassan gluster volume start gv0
fi