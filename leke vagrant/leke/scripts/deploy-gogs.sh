#!/bin/bash

if [ "$(hostname)" = "leke1" ]
then
ipaddr=$(ifconfig eth1| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
else
ipaddr=$(ifconfig eth2| grep "inet addr"| awk '{print $2}' | awk -F ':' '{print $2}')
fi

sudo apt-get install -y glusterfs-client

sed -r /g`hostname`/'s/[0-9\.]+/172.18.0.2/' /vagrant/gluster-hosts-template |sudo tee -a /etc/hosts

echo -e "g`hostname`:/gv0	/app	glusterfs	defaults,_netdev	0	0" |sudo tee -a /etc/fstab
sudo mount -a
