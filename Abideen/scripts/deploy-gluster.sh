#!/bin/bash


if [ "$(hostname)" = "deen1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/bricks
sudo cp /vagrant/gluster-temp /gluster/hosts

sed -i /n$(hostname)/s/$ipaddr/127.0.0.1/ /gluster/hosts

#docker kill deen
#docker rm deen

docker run \
-d --privileged \
-p "$ipaddr:24007:24007" \
-p "$ipaddr:24008:24008" \
-p "$ipaddr:49152:49152" \
-p "$ipaddr:49153:49153" \
-p "$ipaddr:49154:49154" \
-v "/gluster/bricks:/bricks" \
-v "/etc/glusterfs:/etc/glusterfs" \
-v "/var/lib/glusterd:/var/lib/glusterd" \
-v "/var/log/glusterfs:/var/log/glusterfs" \
-v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
-v "/dev:/dev" \
-v "/gluster/hosts:/etc/hosts" \
--name "deen" \
gluster/gluster-centos

if [ "$(hostname)" = "deen3" ]; then
docker exec deen gluster peer probe ndeen1
docker exec deen gluster peer probe ndeen2

sleep 10
docker exec deen gluster volume create gv0 replica 3 ndeen1:/bricks/gv0 ndeen2:/bricks/gv0 ndeen3:/bricks/gv0
docker exec deen gluster volume start gv0
fi