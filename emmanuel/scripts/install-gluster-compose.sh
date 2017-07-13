#!/bin/bash
sudo mkdir -p /vagrants/gluster
sudo cp /vagrant/gluster-install/docker-compose-gluster.yml /vagrants/gluster/docker_comp.yml
sudo cp /vagrant/gluster-install/etc-host/vagrants/gluster/hosts
cd /vagrants/gluster


ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')
sudo sed -i s/addr/"$ipaddr"/ docker_comp.yml

sudo sed -i "s/$ipaddr/127.0.0.1/" hosts

sudo docker_comp up -d
docker exec gluster_gs1_1 mkdir -p /mnt/gluster

if [ "$(hostname)" = "emmanuel" ]; then
        docker exec gluster_gs1_1 gluster peer probe gs1
        docker exec gluster_gs1_1 gluster peer probe gs2

        sleep 3
        docker exec gluster_gs1_1 gluster volume create datapoint replica 3 transport tcp gs1:/mnt/gluster gs2:/mnt/gluster gs3:/mnt/gluster force
        docker exec gluster_gs1_1 gluster volume start datapoint
fi

