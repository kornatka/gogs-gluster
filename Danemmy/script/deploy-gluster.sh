#!/bin/bash



if [ "$(hostname)" = "danemmy1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/gluster-template /gluster/hosts

sed -i /n$(hostname)/s/$ipaddr/127.0.0.1/ /gluster/hosts

docker kill emekaokon
docker rm emekaokon

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
--name "emekaokon" \
gluster/gluster-centos

if [ "$(hostname)" = "danemmy3" ]; then
docker exec emekaokon gluster peer probe ndanemmy1
docker exec emekaokon gluster peer probe ndanemmy2

sleep 10
docker exec emekaokon gluster volume create gv0 replica 3 ndanemmy1:/data/gv0 ndanemmy2:/data/gv0 ndanemmy3:/data/gv0
docker exec emekaokon
gluster volume start gv0
fi