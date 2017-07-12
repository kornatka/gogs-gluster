#!/bin/bash
sudo mkdir -p /velvet/gluster
sudo cp /vagrant/gluster_templates/docker-compose_gluster.yml /velvet/gluster/docker-compose.yml
sudo cp /vagrant/gluster_templates/etc_host_temp /velvet/gluster/hosts
cd /velvet/gluster


ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')
sudo sed -i s/addr/"$ipaddr"/ docker-compose.yml

sudo sed -i "s/$ipaddr/127.0.0.1/" hosts

sudo docker-compose up -d
docker exec gluster_gs1_1 mkdir -p /mnt/gluster

if [ "$(hostname)" = "docker-gluster" ]; then
	docker exec gluster_gs1_1 gluster peer probe gs1
	docker exec gluster_gs1_1 gluster peer probe gs2
	
	sleep 3
	docker exec gluster_gs1_1 gluster volume create datapoint replica 3 transport tcp gs1:/mnt/gluster gs2:/mnt/gluster gs3:/mnt/gluster force
	docker exec gluster_gs1_1 gluster volume start datapoint
fi


