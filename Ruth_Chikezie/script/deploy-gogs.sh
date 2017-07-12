#!/bin/bash

if [ "$(hostname)" = "ruch1" ]
then
ipaddr=$(ifconfig eth1| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

sudo apt-get install -y glusterfs-client jq

glusternode=$(sudo docker inspect dymphna| jq '.[0].NetworkSettings.IPAddress' | awk -F '"' '{print $2}')

sed -r /g`hostname`/'s/[0-9\.]+'/$glusternode/ /vagrant/gluster-hosts-template |sudo tee -a /etc/hosts

echo -e "g`hostname`:/gv0	/app	glusterfs	defaults,_netdev	0	0" |sudo tee -a /etc/fstab

sudo mkdir /app
sudo mount -a

docker run \
-d \
-p "$ipaddr:80:3000" \
-p "$ipaddr:2222:22" \
-v "/app:/data" \
gogs/gogs
