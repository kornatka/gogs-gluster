
if [ "$(hostname)" = "node1" ]; then
	ipaddr=$(ifconfig eth1 | awk '/inet addr/{split($2,a,":"); print a[2]}')
fi

if [ "$(hostname)" = "node2" ]; then
	ipaddr=$(ifconfig eth3 | awk '/inet addr/{split($2,a,":"); print a[2]}')
fi

sudo apt-get install -y glusterfs-client
sudo mkdir /app

sed -r /g`hostname`/'s/[0-9\.]+/172.18.0.2/' /vagrant/gluster/hosts |sudo tee -a /etc/hosts

echo -e "g`hostname`:/gv0	/app	glusterfs	defaults,_netdev	0	0" |sudo tee -a /etc/fstab
sudo mount -a

sudo cp -r /vagrant/gitea /conf/gitea
sudo sed -i s/address/"$ipaddr"/ /conf/gitea/docker-compose.yml

cd /conf/gitea

echo "






"| sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /conf/gitea/nginx-selfsigned.key -out /conf/gitea/nginx-selfsigned.crt

docker-compose up -d --build
