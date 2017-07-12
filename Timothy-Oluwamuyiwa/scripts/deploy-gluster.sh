#!/bin/bash

sudo rm -rf /etc/glusterfs
sudo rm -rf /var/lib/glusterd
sudo rm -rf /var/log/glusterfs
sudo rm -rf /gluster

if [ "$(hostname)" = "muyi1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/gluster-hosts-template /gluster/hosts

sed -i "s/$ipaddr/127.0.0.1/" /gluster/hosts

docker kill muyi
docker rm muyi

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
--name "muyi" \
gluster/gluster-centos

mkdir -p /data/gv0
if [ "$(hostname)" = "muyi3" ]; then
docker exec muyi gluster peer probe  gmuyi1
docker exec muyi gluster peer probe  gmuyi2

sleep 10
docker exec muyi gluster volume create gv0 replica 3 gmuyi1:/data/gv0 gmuyi2:/data/gv0 gmuyi3:/data/gv0
docker exec muyi gluster volume start gv0
fi
