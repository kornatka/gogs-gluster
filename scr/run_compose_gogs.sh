#!/bin/bash
sudo apt-get install glusterfs-client -y
sudo mkdir -p /velvet/gogs
sudo cp /vagrant/gogs_template/docker-compose_gogs.yml /velvet/gogs/docker-compose.yml
sudo cp /vagrant/gogs_template/nginx.conf /velvet/gogs/nginx.conf
sudo cp /vagrant/gluster_templates/etc_host_temp /velvet/gogs/hosts
cd /velvet/gogs
ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')
sudo sed -i "s/$ipaddr/172.0.18.2/" hosts
cat hosts | sudo tee -a /etc/hosts
sudo mkdir /srv/Gogs
sudo mkdir -p /srv/Gogs/etc/nginx
sudo mkdir -p /srv/Gogs/etc/certs

if [ "$(hostname)" = "docker1" ]; then
	ipaddr=$(ifconfig eth1 | awk '/inet addr/{split($2,a,":"); print a[2]}')
	sudo mount -t glusterfs gs1:/datapoint ./var/gogs
	sudo echo"gs1:/datapoint ./var/gogs glusterfs defaults,_netdev 0 0" >> /etc/fstab
fi

if [ "$(hostname)" = "docker2" ]; then
	ipaddr=$(ifconfig eth3 | awk '/inet addr/{split($2,a,":"); print a[2]}')
	sudo mount -t glusterfs gs2:/datapoint ./var/gogs
	sudo echo "gs2:/datapoint ./var/gogs glusterfs defaults,_netdev 0 0" >> /etc/fstab
fi
sudo sed -i s/addr/"$ipaddr"/ docker-compose.yml
# echo "osayp70@gmail.com
# git.domain.com"|sudo docker run -it --rm -p 443:443 -p 80:80 --name letsencrypt \
#             -v "/etc/letsencrypt:/etc/letsencrypt" \
#             -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
#             quay.io/letsencrypt/letsencrypt:latest auth
sudo cd /srv/Gogs/etc/certs
openssl dhparam -out dhparam.pem 2048  
cd /velvet/gogs
docker-compose up -d
