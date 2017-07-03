# NOTE: change interface on machine
# NOTE: also change hosts file templates

ipaddr=$(ifconfig eth2 | awk '/inet addr/{split($2,a,":"); print a[2]}')

sudo mkdir /conf
cp -r /vagrant/gluster /conf/gluster

sudo sed -i -r /g`hostname`/'s/[0-9\.]+/127.0.0.1/' /conf/gluster/hosts
sudo sed -i s/address/"$ipaddr"/ /conf/gluster/docker-compose.yml

cd /conf/gluster
sudo docker-compose up -d

docker exec gluster_gluster_1 mkdir /brick/gv0

if [ "$(hostname)" = "node3" ]; then

	docker exec gluster_gluster_1 gluster peer probe gnode1
	docker exec gluster_gluster_1 gluster peer probe gnode2
	
	sleep 10
	docker exec gluster_gluster_1 gluster volume create gv0 replica 3 gnode1:/brick/gv0 gnode2:/brick/gv0 gnode3:/brick/gv0

	docker exec gluster_gluster_1 gluster volume start gv0
fi
