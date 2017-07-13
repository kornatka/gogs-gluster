#!/bin/bash
sudo mkdir -p /potato/gluster
sudo cp /vagrant/docker-gluster-compose.yml /potato/gluster/docker-compose.yml
sudo cp /vagrant/etc-host /potato/gluster/hosts
cd /potato/gluster


ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')
sudo sed -i s/addr/"$ipaddr"/ docker-compose.yml

sudo sed -i "s/$ipaddr/127.0.0.1/" hosts

sudo docker-compose up -d
docker exec gluster_node1_1 mkdir -p /mnt/gluster

if [ "$(hostname)" = "node3" ]; then
	docker exec gluster_node1_1 gluster peer probe node1
	docker exec gluster_node1_1 gluster peer probe node2
	
	sleep 10
	docker exec gluster_node1_1 gluster volume create datapoint replica 3  node1:/mnt/gluster node2:/mnt/gluster node3:/mnt/gluster force
	docker exec gluster_node1_1 gluster volume start datapoint
fi

