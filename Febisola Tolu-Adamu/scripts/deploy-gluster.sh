#!/bin/bash



if [ "$(hostname)" = "febi1" ]
then
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth3| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

mkdir -p /gluster/data
sudo cp /vagrant/gluster-hosts-template /gluster/hosts

sed -i "/gn$(hostname)/s/$ipaddr/127.0.0.1/" /gluster/hosts




docker run \
-d --privileged \
-p "$ipaddr:24007:24007" \
-p "$ipaddr:24008:24008" \
-p "$ipaddr:49152:49152" \
-p "$ipaddr:49153:49153" \
-p "$ipaddr:49154:49154" \
-v "/gluster/data:/data" \
-v "/etc/glusterfs:/etc/glusterfs" \
-v "/var/lib/glusterd:/var/lib/glusterd" \
-v "/var/log/glusterfs:/var/log/glusterfs" \
-v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
-v "/dev:/dev" \
-v "/gluster/hosts:/etc/hosts" \
--name "febi" \
gluster/gluster-centos

mkdir -p /data/gv0

if [ "$(hostname)" = "febi3" ]; then
docker exec febi gluster peer probe  gnfebi1
docker exec febi gluster peer probe  gnfebi2

sleep 10
docker exec febi gluster volume create gv0 replica 3 gnfebi1:/bricks/gv0 gnfebi2:/bricks/gv0 gnfebi3:/bricks/gv0
docker exec febi gluster volume start gv0
fi
