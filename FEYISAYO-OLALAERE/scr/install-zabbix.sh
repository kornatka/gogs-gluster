#!/bin/bash
sudo apt install zabbix-agent -y
sudo service zabbix-agent stop
if [ "$(hostname)" = "docker1" ]; then
	sudo cp /vagrant/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
	sudo sed -i /Hostname/s/feyi-docker/feyi-docker1/ \
/etc/zabbix/zabbix_agentd.conf
fi
if [ "$(hostname)" = "docker2" ]; then
	sudo cp /vagrant/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
	sudo sed -i /Hostname/s/feyi-docker/feyi-docker2/ \
/etc/zabbix/zabbix_agentd.conf
fi
if [ "$(hostname)" = "docker-gluster" ]; then
	sudo cp /vagrant/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
	sudo sed -i /Hostname/s/feyi-docker/feyi-docker3/ \
/etc/zabbix/zabbix_agentd.conf
fi
sudo systemctl restart zabbix-agent
