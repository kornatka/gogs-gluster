SCALE=3
SCALE=$(($SCALE + 1))

sudo cp /vagrant/gitea/nginx_template.conf /conf/gitea/nginx.conf

for ((i=0;i<$SCALE;i++)); do
	sudo sed -i $(($i+1))a"server 172.19.0.$(($i + 2)):3000;" /conf/gitea/nginx.conf
done

cd /conf/gitea
docker-compose down
docker-compose up -d --scale app=$SCALE
