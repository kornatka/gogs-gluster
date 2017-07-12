#!/bin/bash
sudo apt-get install glusterfs-client -y
sudo mkdir -p /vagrants/gogs
sudo cp /vagrant/gogs-install/docker-compose.yml /vagrants/gogs/docker_comp.yml
sudo cp /vagrant/gogs-install/nginx.conf /vagrants/gogs/nginx.conf
sudo cp /vagrant/gluster-install/etc-host temp /vagrants/gogs
cd /vagrants/gogs
ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')
sudo sed -i "s/$ipaddr/172.0.18.2/" hosts
cat hosts | sudo tee -a /etc/hosts
sudo mkdir /srv/Gogs
sudo mkdir -p /srv/Gogs/etc/nginx
sudo mkdir -p /srv/Gogs/etc/certs

if [ "$(hostname)" = "ayo1" ]; then
        ipaddr=$(ifconfig eth1 | awk '/inet addr/{split($2,a,":"); print a[2]}')
        sudo mount -t glusterfs gs1:/datapoint ./var/gogs
        sudo echo"gs1:/datapoint ./var/gogs glusterfs defaults,_netdev 0 0" >> /etc/fstab
fi

if [ "$(hostname)" = "ayo2" ]; then
        ipaddr=$(ifconfig eth3 | awk '/inet addr/{split($2,a,":"); print a[2]}')
        sudo mount -t glusterfs gs2:/datapoint ./var/gogs
        sudo echo "gs2:/datapoint ./var/gogs glusterfs defaults,_netdev 0 0" >> /etc/fstab
fi
sudo sed -i s/addr/"$ipaddr"/ docker_comp.yml
sudo cd /srv/Gogs/etc/certs
openssl dhparam -out dhparam.pem 2048
cd /vagrants/gogs
#docker_comp up -d

